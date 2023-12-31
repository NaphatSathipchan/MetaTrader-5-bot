//+------------------------------------------------------------------+
//|                                            ButtonClickExpert.mq5 |
//|                        Copyright 2009, MetaQuotes Software Corp. |
//|                                              https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "2009, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>  

CTrade         trade;
CSymbolInfo    m_symbol;  
double Ask,Bid;
double balance=AccountInfoDouble(ACCOUNT_BALANCE);
double equity=AccountInfoDouble(ACCOUNT_EQUITY);
double marginlevel=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
double margin=AccountInfoDouble(ACCOUNT_MARGIN);
double marginfree=AccountInfoDouble(ACCOUNT_MARGIN_FREE);
double profit=AccountInfoDouble(ACCOUNT_PROFIT);



string buttonID="Buy";
string buttonIDD="Sell";
string buttonIDDD="CLOSE ALL";
string labelID="DAD";
string labelIDD="BALANCE";
string labelIDDD="Equity";
string labelIa="Margin";
string labelIc="MarginFree";
string labelIb="MarginLevel";
string labelId="Infolosad";
string labelIf="macd";
string labelIg="rsi";
string labelIh="adx";
string labelIz="adx+";
string labelIx="adx-";
int    handle_iADX;


int broadcastEventID=5000;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  handle_iADX=iADX(m_symbol.Name(),Period(),9);
    
    
   if(handle_iADX==INVALID_HANDLE)
     {
     
      PrintFormat("Failed to create handle of the iADX indicator for the symbol %s/%s, error code %d",
                  m_symbol.Name(),
                  EnumToString(Period()),
                  GetLastError());
      
      return(INIT_FAILED);
      }
//--- Create a button to send custom events
   ObjectCreate(0,buttonID,OBJ_BUTTON,0,100,100);
   ObjectSetInteger(0,buttonID,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,buttonID,OBJPROP_BGCOLOR,clrGreen);
   ObjectSetInteger(0,buttonID,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,buttonID,OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,buttonID,OBJPROP_XSIZE,50);
   ObjectSetInteger(0,buttonID,OBJPROP_YSIZE,50);
   ObjectSetString(0,buttonID,OBJPROP_FONT,"Arial");
   ObjectSetString(0,buttonID,OBJPROP_TEXT,"Buy");
   ObjectSetInteger(0,buttonID,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,buttonID,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,buttonIDD,OBJ_BUTTON,0,100,100);
   ObjectSetInteger(0,buttonIDD,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,buttonIDD,OBJPROP_BGCOLOR,clrRed);
   ObjectSetInteger(0,buttonIDD,OBJPROP_XDISTANCE,150);
   ObjectSetInteger(0,buttonIDD,OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,buttonIDD,OBJPROP_XSIZE,50);
   ObjectSetInteger(0,buttonIDD,OBJPROP_YSIZE,50);
   ObjectSetString(0,buttonIDD,OBJPROP_FONT,"Arial");
   ObjectSetString(0,buttonIDD,OBJPROP_TEXT,"Sell");
   ObjectSetInteger(0,buttonIDD,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,buttonIDD,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,buttonIDDD,OBJ_BUTTON,0,100,100);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_XDISTANCE,200);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_YDISTANCE,100);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_XSIZE,100);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_YSIZE,50);
   ObjectSetString(0,buttonIDDD,OBJPROP_FONT,"Arial");
   ObjectSetString(0,buttonIDDD,OBJPROP_TEXT,"Close All");
   ObjectSetInteger(0,buttonIDDD,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,buttonIDDD,OBJPROP_SELECTABLE,0);
 
//--- Create a label for displaying information
   ObjectCreate(0,labelID,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelID,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelID,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelID,OBJPROP_YDISTANCE,50);
   ObjectSetString(0,labelID,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelID,OBJPROP_TEXT,"ขาดทุนคือกำไร พ่อหลวงสอนไว้");
   ObjectSetInteger(0,labelID,OBJPROP_FONTSIZE,20);
   ObjectSetInteger(0,labelID,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelIDD,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIDD,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIDD,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIDD,OBJPROP_YDISTANCE,150);
   ObjectSetString(0,labelIDD,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIDD,OBJPROP_TEXT,"Balance: "+balance);
   ObjectSetInteger(0,labelIDD,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIDD,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelIDDD,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIDDD,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIDDD,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIDDD,OBJPROP_YDISTANCE,170);
   ObjectSetString(0,labelIDDD,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIDDD,OBJPROP_TEXT,"Equity: "+equity);
   ObjectSetInteger(0,labelIDDD,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIDDD,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelIa,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIa,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIa,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIa,OBJPROP_YDISTANCE,190);
   ObjectSetString(0,labelIa,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIa,OBJPROP_TEXT,"Margin: "+margin);
   ObjectSetInteger(0,labelIa,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIa,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelIb,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIb,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIb,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIb,OBJPROP_YDISTANCE,210);
   ObjectSetString(0,labelIb,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIb,OBJPROP_TEXT,"MarginFree: "+marginfree);
   ObjectSetInteger(0,labelIb,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIb,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelIc,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIc,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIc,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIc,OBJPROP_YDISTANCE,230);
   ObjectSetString(0,labelIc,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIc,OBJPROP_TEXT,"MarginLevel:  "+marginlevel  );
   ObjectSetInteger(0,labelIc,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIc,OBJPROP_SELECTABLE,0);
   
   ObjectCreate(0,labelId,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelId,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelId,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelId,OBJPROP_YDISTANCE,250);
   ObjectSetString(0,labelId,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelId,OBJPROP_TEXT,"profit: "+profit);
   ObjectSetInteger(0,labelId,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelId,OBJPROP_SELECTABLE,0);
   
   double macdSiao[];
   int MacDPom=iMACD(_Symbol,PERIOD_CURRENT,15,35,9,PRICE_CLOSE);
   CopyBuffer(MacDPom,0,0,3,macdSiao);
   

   double MacDValue=(macdSiao[2]);
   ObjectCreate(0,labelIf,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIf,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIf,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIf,OBJPROP_YDISTANCE,270);
   ObjectSetString(0,labelIf,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIf,OBJPROP_TEXT,"macdvalue: "+MacDValue);
   ObjectSetInteger(0,labelIf,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIf,OBJPROP_SELECTABLE,0);
   
   double rsiSiao[];
   int RSI=iRSI(_Symbol,PERIOD_CURRENT,14,PRICE_CLOSE);
   CopyBuffer(RSI,0,0,3,rsiSiao);
   int RSIValue=(rsiSiao[2]);
   ObjectCreate(0,labelIg,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIg,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIg,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIg,OBJPROP_YDISTANCE,290);
   ObjectSetString(0,labelIg,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIg,OBJPROP_TEXT,"rsivalue: "+RSIValue);
   ObjectSetInteger(0,labelIg,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIg,OBJPROP_SELECTABLE,0);
    
   
   double adx_values[]; 
   
   int ADX=iADX(_Symbol,PERIOD_CURRENT,9);
   CopyBuffer(ADX,0,0,3,adx_values);
   int ADXValue=NormalizeDouble(adx_values[2],2);
   ObjectCreate(0,labelIh,OBJ_LABEL,0,100,100);
   ObjectSetInteger(0,labelIh,OBJPROP_COLOR,clrYellow);
   ObjectSetInteger(0,labelIh,OBJPROP_XDISTANCE,100);
   ObjectSetInteger(0,labelIh,OBJPROP_YDISTANCE,310);
   ObjectSetString(0,labelIh,OBJPROP_FONT,"Arial");
   ObjectSetString(0,labelIh,OBJPROP_TEXT,"adxvalue: "+ADXValue);
   ObjectSetInteger(0,labelIh,OBJPROP_FONTSIZE,10);
   ObjectSetInteger(0,labelIh,OBJPROP_SELECTABLE,0);
   
   
   
   Print("macd:  ", DoubleToString(MacDValue,6) );
   Print("rsi:  ", RSIValue );
   Print("adx:  ", ADXValue );
   
   
   
   
   
   
   
   
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0,buttonID);
   ObjectDelete(0,labelID);
   
  }


void OnTick()
  {
   Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   string kuytu="";
  
  
   double macdSiao[];
   double rsiSiao[];
   double adx_values[];
   
   
   ArraySetAsSeries(macdSiao,true);
   ArraySetAsSeries(rsiSiao,true);
   ArraySetAsSeries(adx_values,true);
   
   
   
   int MacDPom=iMACD(_Symbol,PERIOD_CURRENT,15,35,9,PRICE_CLOSE);
   int RSI=iRSI(_Symbol,PERIOD_CURRENT,14,PRICE_CLOSE);
   int ADX=iADX(_Symbol,PERIOD_CURRENT,9);
   
   
   CopyBuffer(MacDPom,0,0,3,macdSiao);
   CopyBuffer(RSI,0,0,3,rsiSiao);
   CopyBuffer(ADX,0,0,3,adx_values);
   
   double MacDValue=(macdSiao[0]);
   double RSIValue=(rsiSiao[2]);
   double ADXValue=NormalizeDouble(adx_values[2],2);
   
   
   Print("macd:  ", MacDValue );
   
   if (MacDValue>0 && ( RSIValue <50 )  && ADXValue >25  )
   kuytu="sell";
   
   if (MacDValue<0 && ( RSIValue >50 )   && ADXValue >25 )
   kuytu="buy";
   
   if (kuytu=="sell" && PositionsTotal()<1 )   
                               //stop loss//                      //take profit//
    trade.Sell (0.01,NULL,Bid,(Bid+200 * _Point),(Bid-100 * _Point),NULL);
    
        
   if (kuytu=="buy" && PositionsTotal()<1  )
    trade.Buy (0.01,NULL,Ask,(Ask-200 * _Point),(Ask+100  * _Point),NULL);    
    Comment("The Signal is now: ",kuytu);
    
    
   
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- Check the event by pressing a mouse button
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
          if(sparam==buttonID)
          {          
            trade.Buy(0.01,NULL,Ask,(Ask-150 * _Point),(Ask+100  * _Point),NULL);
            
          }
          else if(sparam==buttonIDD)
          {          
            trade.Sell(0.01,NULL,Bid,(Bid+150 * _Point),(Bid-100 * _Point),NULL); 
                      
          }
          else if(sparam==buttonIDDD)
          {          
            CloseAllBuyPostions();
            
          }
    }
    
    

 
 
//--- Check the event belongs to the user events
   if(id>CHARTEVENT_CUSTOM)
     {
      if(id==broadcastEventID)
        {
         Print("Got broadcast message from a chart with id = "+lparam);
        }
      else
        {
         //--- We read a text message in the event
         string info=sparam;
         Print("Handle the user event with the ID = ",id);
         //--- Display a message in a label
         ObjectSetString(0,labelID,OBJPROP_TEXT,sparam);
         ChartRedraw();// Forced redraw all chart objects
        }
     }
  }
//+------------------------------------------------------------------+
//| sends broadcast event to all open charts                         |
//+------------------------------------------------------------------+

void BroadcastEvent(long lparam,double dparam,string sparam)
  {
   int eventID=broadcastEventID-CHARTEVENT_CUSTOM;
   long currChart=ChartFirst();
   int i=0;
   while(i<CHARTS_MAX)                 // We have certainly no more than CHARTS_MAX open charts
     {
      EventChartCustom(currChart,eventID,lparam,dparam,sparam);
      currChart=ChartNext(currChart); // We have received a new chart from the previous
      if(currChart==-1) break;        // Reached the end of the charts list
      i++;// Do not forget to increase the counter
     }
  }

void CloseAllBuyPostions()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
   {
      int ticket=PositionGetTicket(i);
      int PositionDirection=PositionGetInteger(POSITION_TYPE);
      if(PositionDirection==POSITION_TYPE_BUY||POSITION_TYPE_SELL)
      
      trade.PositionClose(ticket);
    }
  
  }