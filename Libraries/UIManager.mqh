//+------------------------------------------------------------------+
//|                                                    UIManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"
class UIManager
  {
private:

public:
                     UIManager();
                    ~UIManager();
int objCount;

   void              displayTradeSignal(TradeSignal& tradeSignal)
     {
      Print("UI > displayTradeSignal");
      ObjectCreate(0,"BUY"+IntegerToString(objCount),OBJ_ARROW_THUMB_UP,0,TimeCurrent(),tradeSignal.price);
      objCount++;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UIManager::UIManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
UIManager::~UIManager()
  {
  }
//+------------------------------------------------------------------+
