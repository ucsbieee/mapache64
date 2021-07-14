# License: Apache v2. See LICENSE file in module directory.

import io
import numpy as np
from typing import Dict, Union, List

from pathlib import Path


def _unsigned_dtype(n_bits):
    if n_bits==1:
        return np.bool_
    elif n_bits<=8:
        return np.uint8
    elif n_bits<=16:
        return np.uint16
    elif n_bits<=32:
        return np.uint32
    elif n_bits<=64:
        return np.uint64

def _signed_dtype(n_bits):
    if n_bits==1:
        return np.bool_
    elif n_bits<=8:
        return np.int8
    elif n_bits<=16:
        return np.int16
    elif n_bits<=32:
        return np.int32
    elif n_bits<=64:
        return np.int64


class Signal():
    __slots__ = ['width','_dat','_cache_signed','_cache_unsigned','max_tstep']
    width: int
    _dat: Dict[int,int]
    max_tstep: int
    def __init__(self,width:int,initval:int):
        assert width>0
        assert initval>=0
        self.width=width
        self._dat={0:initval}
        self._cache_signed = None
        self._cache_unsigned = None
        self.max_tstep = 0

    def __str__(self):
        return '[{}:0]'.format(self.width-1)

    def __getitem__(self,t:int):
        return self._dat[t]

    def __setitem__(self,t:int,newval:int):
        self._dat[t] = newval

    @property
    def unsigned(self):
        if self._cache_unsigned is None:
            result = np.ndarray(self.max_tstep,dtype=_unsigned_dtype(self.width))
            if self.width<2:
                translations:Dict[int,int]={0:0,1:1,2:0,3:0}
                for t in range(self.max_tstep):
                    if t in self._dat:
                        result[t]=translations[self._dat[t]]
                    else:
                        result[t]=result[t-1]
            else:
                for t in range(self.max_tstep):
                    result[t]=self._dat.get(t,result[t-1])
            self._cache_unsigned = result
        return self._cache_unsigned

    @property
    def signed(self):
        if self._cache_signed is None:
            unsigned = self.unsigned
            if self.width<2:
                return unsigned
            else:
                sign_bit = 1<<(self.width-1)
                mask = ~((~0)<<(self.width))
                negs = (sign_bit & unsigned)>0
                local_dat = unsigned.astype(_signed_dtype(self.width))
                local_dat[negs] = -((1+~local_dat[negs])&mask)
                self._cache_signed = local_dat
        return self._cache_signed

class VCD():
    __slots__ = ['_sigs','translations']

    _sigs: Dict[str,Signal]
    translations: Dict[str,str]

    def __init__(self,signals:dict,translations:dict,max_tstep:int) -> None:
        self._sigs = dict()
        for ident,sig in signals.items():
            sig.max_tstep = max_tstep
            self._sigs[ident] = sig
        self.translations = translations

    def __str__(self) -> str:
        return "VCD: {}".format(self.translations)

    def __getitem__(self, key):
        r = self._sigs.get(key,None)
        if r is None:
            r = self._sigs[self.translations[key]]
        return r

def read_vcd(s,signals=None):
    def _open_reading_file(f,extension):
        if isinstance(f,str):
            if ' ' in f and not extension in f:
                # Assume given string is contents
                return io.StringIO(f)
            else:
                # Assume given string is file path
                return open(f,'r')
        else:
            raise "I don't know what I'm doing w/ this object"

    def _concat_map(fn,i):
        for item in i:
            for subitem in fn(item):
                yield subitem

    # Open and read the file
    with _open_reading_file(s,'.vcd') as infile:
        infile_tokens = _concat_map(lambda s:s.rstrip().split(),infile)
        sig_defs: Dict[str,int] = dict()
        translations: Dict[str,str] = dict()
        scopecontext: List[str] = list()
        tok:str = next(infile_tokens)
        while True:
            if tok in ['$date','$version','$timescale']:
                while tok != '$end':
                    tok:str = next(infile_tokens)
            elif tok == '$scope':
                typ:str = next(infile_tokens)
                ident:str = next(infile_tokens)
                if typ not in ['module','begin']:
                    raise ValueError('Scope {}.{} has unsupported type {}'.format('.'.join(scopecontext),ident,typ))
                scopecontext.append(ident)
                assert next(infile_tokens)=='$end'
            elif tok=='$upscope':
                scopecontext.pop()
                assert next(infile_tokens)=='$end'
            elif tok=='$var':
                typ:str = next(infile_tokens)
                width:int = int(next(infile_tokens))
                short_ident:str = next(infile_tokens)
                long_ident:str = '.'.join(scopecontext)+'.'+next(infile_tokens)
                if width > 1:
                    assert next(infile_tokens)!='$end' # Discard bus notation
                if signals is None or long_ident in signals:
                    if typ not in ['wire','reg','integer']:
                        raise ValueError('Var {}.{} has unsupported type {}'.format('.'.join(scopecontext),long_ident,typ))
                    sig_defs[short_ident] = width
                    translations[long_ident] = short_ident
                assert next(infile_tokens)=='$end'
            elif tok=='$enddefinitions':
                assert next(infile_tokens)=='$end'
                tok:str = next(infile_tokens)
                assert tok=='#0'
                break

            tok:str = next(infile_tokens)
            if tok=='#0':
                break

        # assert clksig is None or clkident is not None

        # Now we process dumpvar initial values
        assert next(infile_tokens)=='$dumpvars'
        sigs:Dict[str,Signal] = dict()

        tok:str = next(infile_tokens)
        while tok != '$end':
            if tok[0]=='b':
                short_ident:str = next(infile_tokens)
                if short_ident in sigs:
                    val:int = int(tok[1:],2) if 'x' not in tok[1:] else 0
            else:#elif tok[0] in '10xz':
                val:int = {'0':0,'1':1,'x':2,'z':3}[tok[0]] #ord(tok[0]) & 0x3
                short_ident:str = tok[1:]
            # else:
            #     raise ValueError("Unexpected first character of token in $dumpvars: "+tok)

            if short_ident in sig_defs:
                width = sig_defs[short_ident]
                sigs[short_ident] = Signal(width,val)
            # elif short_ident==clkident:
            #     clkval:int = val

            tok:str = next(infile_tokens)

        # Iterate all time changes
        timestep:int = 0
        for tok in infile_tokens:
            if tok[0]=='#':
                timestep:int=int(tok[1:])
                # if timestep % 1000000 == 0:
                #     print(timestep)
            elif tok[0] in 'b10xz':
                if tok[0] == 'b':
                    short_ident:str = next(infile_tokens)
                    if short_ident in sigs:
                        try:
                            val:int = int(tok[1:],2)
                        except ValueError:
                            val:int = int(tok[1:].replace('x','0'),2)
                else:
                    val:int = {'0':0,'1':1,'x':2,'z':3}[tok[0]]
                    short_ident:str = tok[1:]
                if short_ident in sigs:
                    sigs[short_ident][timestep] = val
            else:
                raise ValueError("Unexpected non-timestamp and non-change token in stream after definitions: {}".format(tok))

    return VCD(sigs,translations,timestep)

def read_clocked_vcd(vcd_name:Union[str,Path],signals:Union[str,List[str]],clk:str):
    def rising_edges(clk):
        clk[1:] = np.logical_and(clk[1:]==True,clk[:-1]==False)
        return clk

    if isinstance(signals,str): signals = [signals]

    vcd_file = Path(vcd_name)
    sigs = read_vcd(vcd_name,signals+[clk])
    clksig = sigs[clk].unsigned
    edges = rising_edges(clksig)
    return [sigs[signal].unsigned[edges] for signal in signals]
