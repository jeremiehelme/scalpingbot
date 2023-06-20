//+------------------------------------------------------------------+
//|                                                 TimeInterval.mqh |
//|                                    Copyright 2023, Jeremie Helme |
//|                                      https://www.jeremiehelme.fr |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Jeremie Helme"
#property link      "https://www.jeremiehelme.fr"
#property version   "1.00"
class TimeInterval
  {
private:

public:

   datetime          start;
   datetime          end;
                     TimeInterval()
     {
     
     }
     
     TimeInterval(datetime _start, datetime _end)
     {
      start = _start;
      end= _end;
     }
     
     bool timeIsBetween(datetime current) {
      
      if(current == NULL || start == NULL || end == NULL) {
         return false;
      }
      
      MqlDateTime currentStruct;
      TimeToStruct(current,currentStruct);
      
      MqlDateTime startStruct;
      TimeToStruct(start,startStruct);
      
      MqlDateTime endStruct;
      TimeToStruct(end,endStruct);

      return (currentStruct.hour >= startStruct.hour) && (currentStruct.min >= startStruct.min)  && (currentStruct.hour < endStruct.hour) && (currentStruct.min < endStruct.min); 
     }


  };
//+------------------------------------------------------------------+
