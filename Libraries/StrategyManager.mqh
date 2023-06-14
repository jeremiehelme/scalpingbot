//+------------------------------------------------------------------+
//|                                              StrategyManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "../Include/Constants.mqh"
#include "../Model/Signal.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StrategyManager
  {
private:

   typedef void      (*SignalEvent)(Signal& signal);
   SignalEvent       signalEvent;

   int               ema200Handle;
   int               stochHandle;

   trendEnum         trend;

   double            ma200[];
   double            stochK[];
   double            stochD[];
public:
                     StrategyManager();
                    ~StrategyManager();

   void              init(SignalEvent OnSignal)
     {
      signalEvent = OnSignal;
     }

   trendEnum         getTrend(double bid)
     {

      if(bid == 0 || ma200.Size() == 0)
        {
         return notrend;
        }

      if(ma200[0] > bid)
        {
         return downtrend;
        }
      else
         if(ma200[0] < bid)
           {
            return uptrend;
           }
      return notrend;
     };


   void              OnTick()
     {
      CopyBuffer(ema200Handle,0,0,1,ma200);
      CopyBuffer(stochHandle,0,0,1,stochK);
      CopyBuffer(stochHandle,1,0,1,stochD);

      double bid =  SymbolInfoDouble(_Symbol, SYMBOL_BID);
      trend = getTrend(bid);


      if(trend == uptrend)
        {
         Signal signal(buy,bid);
         signalEvent(signal);
        }


     };


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StrategyManager::StrategyManager()
  {
   ema200Handle = iMA(_Symbol,PERIOD_M1,200,0,MODE_EMA,0);
   stochHandle = iStochastic(_Symbol,PERIOD_M1,14,3,4,MODE_SMA,STO_LOWHIGH);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StrategyManager::~StrategyManager()
  {
  }
//+------------------------------------------------------------------+