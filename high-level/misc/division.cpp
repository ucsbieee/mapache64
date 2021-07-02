#include<iostream>
using namespace std;
uint16_t division(uint16_t dividend, uint16_t divisor){
    uint16_t quotient;
    uint32_t divisor_slider = ((uint32_t) divisor) << 16; ////(divisor)000....0000
    //Compare divisor_slider to dividend
    for(int i = 0; i<17; i++)
    {
        if(divisor_slider <= dividend)
        {
            dividend -= divisor_slider;
            quotient = (quotient << 1) | 1;
        }
        else
        { // divisor_slider > dividend
            quotient = quotient << 1;
        }
        divisor_slider = divisor_slider >> 1;
    }
    return quotient;
}
int main()
{
    cout<<division(100,3)<<endl;
    return 0;
}
