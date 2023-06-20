//+------------------------------------------------------------------+
//|                                              StrategyManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"

#include "../Include/Constants.mqh"
#include "../Model/TradeSignal.mqh"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StrategyManager
  {
private:

   trendEnum         trend;

   typedef void      (*TradeSignalEvent)(TradeSignal& signal);
   TradeSignalEvent       onTradeSignal;

   int               ema200Handle;
   int               stochHandle;

   double            ema200[];
   double            stochK[];
   double            stochD[];

   bool              orderSent;
   
   int TP_TICKS;
   int SL_TICKS;
   double tradeSpread;


   double            getMidPreviousCandle()
     {

      MqlRates previousBar[]; 
      ArraySetAsSeries(previousBar,true);
      CopyRates(_Symbol,PERIOD_M1,0,2,previousBar);
      Print("SM > Previous bar : HIGH "+previousBar[1].high+" LOW "+previousBar[1].low);
      return previousBar[1].high - ((previousBar[1].high - previousBar[1].low)/2);

     }

public:
                     StrategyManager();
                    ~StrategyManager();

   void              init(TradeSignalEvent _onTradeSignal)
     {
      onTradeSignal = _onTradeSignal;
      orderSent = false;
     }

   trendEnum         getTrend(MqlTick& tick)
     {
      if(tick.last == 0 || ema200.Size() == 0)
        {
         return notrend;
        }

      if(ema200[0] > tick.last)
        {
         return downtrend;
        }
      else
         if(ema200[0] < tick.last)
           {
            return uptrend;
           }
      return notrend;
     };


   void              OnTick(MqlTick& tick)
     {
      CopyBuffer(ema200Handle,0,0,1,ema200);
      CopyBuffer(stochHandle,MAIN_LINE,0,1,stochK);
      CopyBuffer(stochHandle,SIGNAL_LINE,0,1,stochD);

      double bid =  SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double ask =  SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      
      trend = getTrend(tick);

      //uptrend && under 20 && cross && order not sent
      if(trend == uptrend && stochK[0] < 20 && stochK[0] > stochD[0] && !orderSent)
        {
         Print("UPTREND BUY stochK[0] < 20 ("+DoubleToString(stochK[0])+") D < K ("+stochD[0]+")" );
         orderSent = true;
         double midPreviousCandle = getMidPreviousCandle();
         TradeSignal tradeSignal(buy,ask,ask - SymbolInfoDouble(_Symbol,SYMBOL_POINT) *SL_TICKS, ask + (4*tradeSpread));
         onTradeSignal(tradeSignal);
         return;
        }
      //downtrend && above 80 && cross && order not sent
      if(trend == downtrend  && stochK[0] > 80 && stochK[0] < stochD[0] && !orderSent)
        {
        
         Print("DOWNTREND SELL stochK[0] > 80 ("+DoubleToString(stochK[0])+") D > K ("+stochD[0]+")" );
         orderSent = true;
         double midPreviousCandle = getMidPreviousCandle();
         TradeSignal tradeSignal(sell,bid,bid + SymbolInfoDouble(_Symbol,SYMBOL_POINT) *SL_TICKS, bid - (4*tradeSpread));
         onTradeSignal(tradeSignal);
         return;
        }

      //reset order when stoch is neutral
      if(stochD[0] > 20 && stochD[0] < 80 && stochK[0] > 20 && stochK[0] < 80)
        {
         orderSent = false;
        }


     };


  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StrategyManager::StrategyManager()
  {
   SL_TICKS = 40;
   TP_TICKS = 60;
   ema200Handle = iMA(_Symbol,PERIOD_M1,200,0,MODE_EMA,PRICE_CLOSE);
   stochHandle = iStochastic(_Symbol,PERIOD_M1,14,3,4,MODE_SMA,STO_CLOSECLOSE);
   tradeSpread = SymbolInfoDouble(_Symbol,SYMBOL_POINT) * (SYMBOL_TRADE_STOPS_LEVEL+1);
      
   ChartIndicatorAdd(0,0,ema200Handle);
   ChartIndicatorAdd(0,0,stochHandle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StrategyManager::~StrategyManager()
  {
  }
//+------------------------------------------------------------------+
