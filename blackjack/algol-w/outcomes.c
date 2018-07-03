#include "alw.h"

static const char * const alw_src = "outcomes.alw";


   int main (int argc, char **argv) {
     alw_init(alw_at(55,0));
     {
const int _deck_lwb1 = 0, _deck_upb1 = 9;
{
auto int partitions(int * cards(alw_loc,int), int * (*subtotal)(void));
auto int * deck(alw_loc loc, int _sub1);
int _deck_array[_deck_upb1 - _deck_lwb1 + 1];
int d;
int p;
int * deck(alw_loc loc, int _sub1) 
     {
       alw_array_range_check(deck, 1);
       return &_deck_array[_sub1 - _deck_lwb1];
     }
    int partitions(int * cards(alw_loc,int), int * (*subtotal)(void)) {
return ({
({
int m;
int total;
int loop;
m = 0;
total = 0;
loop = 0;
m = 0;
loop = 1;
{ 
             const int _start = 0;
             const int _limit = 9;
             int i = _start;
             while (i <= _limit) {
               {
{
if ((loop && (*cards(alw_at(11,19), i) > 0)))
 {
{
total = ((*subtotal() + i) + 1);
if ((total < 21))
 {
{
m = (m + 1);
*cards(alw_at(17,1), i) = (*cards(alw_at(17,13), i) - 1);
m = (m + ({
int * _partitions_arg2(void){ return &total; }
int _partitions_ret;
_partitions_ret = partitions(cards, _partitions_arg2);
_partitions_ret;
})
);
*cards(alw_at(19,1), i) = (*cards(alw_at(19,13), i) + 1);
; /*empty*/
}
}
 
 else 
 {
{
if ((total == 21))
 m = (m + 1);
; /*empty*/
}
}
 
; /*empty*/
}
}
; /*empty*/
}
}

               ++i;
             }
           }
          m;
});
});
 }
{ 
       int _sub1;
       alw_array_bounds_check(deck, alw_at(31,0), 1);
       for (_sub1 = _deck_lwb1; _sub1 <= _deck_upb1; ++_sub1) 
       _deck_array[_sub1 - _deck_lwb1] = 0;

     }
    d = 0;
p = 0;
{ 
             const int _start = 0;
             const int _limit = 8;
             int i = _start;
             while (i <= _limit) {
               *deck(alw_at(35,2), i) = 4;

               ++i;
             }
           }
          *deck(alw_at(36,0), 9) = 16;
d = 0;
{ 
             const int _start = 0;
             const int _limit = 9;
             int i = _start;
             while (i <= _limit) {
               {
{
*deck(alw_at(41,2), i) = (*deck(alw_at(41,13), i) - 1);
p = 0;
{ 
             const int _start = 0;
             const int _limit = 9;
             int j = _start;
             while (j <= _limit) {
               {
{
*deck(alw_at(45,4), j) = (*deck(alw_at(45,15), j) - 1);
p = (p + ({
int _partitions_arg2_temp;
int * _partitions_arg2(void){ _partitions_arg2_temp = (j + 1);
; return &_partitions_arg2_temp; }
int _partitions_ret;
_partitions_ret = partitions(deck, _partitions_arg2);
_partitions_ret;
})
);
*deck(alw_at(47,4), j) = (*deck(alw_at(47,15), j) + 1);
; /*empty*/
}
}

               ++j;
             }
           }
          { alw_Editing_t _editing_state;
                 alw_Editing_save(&_editing_state);
                 alw_iocontrol(alw_at(49,2), 2);
i_w = 1;
alw_write_string(alw_at(49,2), (alw_str)"Dealer showing ", 15);
alw_write_integer(alw_at(49,2), i);
alw_write_string(alw_at(49,2), (alw_str)" partitions = ", 14);
alw_write_integer(alw_at(49,2), p);

                 alw_Editing_restore(&_editing_state);
               }
              d = (d + p);
*deck(alw_at(51,2), i) = (*deck(alw_at(51,13), i) + 1);
}
}

               ++i;
             }
           }
          { alw_Editing_t _editing_state;
                 alw_Editing_save(&_editing_state);
                 alw_iocontrol(alw_at(53,0), 2);
i_w = 1;
alw_write_string(alw_at(53,0), (alw_str)"Total partitions = ", 19);
alw_write_integer(alw_at(53,0), d);

                 alw_Editing_restore(&_editing_state);
               }
              ; /*empty*/
}
}
alw_exit(alw_at(55,0), 0);
     return 0;
   }
   
