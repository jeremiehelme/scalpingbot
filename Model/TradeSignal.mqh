//+------------------------------------------------------------------+
//|                                                       Signal.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "../Include/Constants.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TradeSignal
  {
private:

public:

   OrderTypeEnum    type;
   double            price;
   double            sl;
   double            tp;

                     TradeSignal(OrderTypeEnum _type, double _price, double _sl, double _tp)
     {
      type = _type;
      price = _price;
      sl = _sl;
      tp = _tp;
     }
  };
//+------------------------------------------------------------------+
