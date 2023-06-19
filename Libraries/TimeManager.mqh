//+------------------------------------------------------------------+
//|                                                  TimeManager.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"


#include "../Model/TimeInterval.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TimeManager
  {
private:
   TimeInterval      excludedHours[100];
public:
                     TimeManager();
                    ~TimeManager();


   void              init()
     {
      excludedHours[0] = TimeInterval(StringToTime("11:00:00"),StringToTime("14:00:00"));
     }

   bool              allowedInterval(datetime  current)
     {
      bool isAllowed = true;
      for(int i = 0; i < 1; i++)
        {
         if(excludedHours[i].timeIsBetween(current))
           {
            isAllowed = false;
           }
        }
      return isAllowed;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TimeManager::TimeManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TimeManager::~TimeManager()
  {
  }
//+------------------------------------------------------------------+
