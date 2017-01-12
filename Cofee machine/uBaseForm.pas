unit uBaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RegExpr, uGenerics;

type

  TForm1 = class(TForm)
    rgMoneySelector: TRadioGroup;
    lMoneyStack: TListBox;
    btAddMoney: TButton;
    btCancelPurchase: TButton;
    Product: TGroupBox;
    lbTotalAmount: TLabel;
    rgProductSelector: TRadioGroup;
    lChange: TListBox;
    Label1: TLabel;
    lbTotalChange: TLabel;
    btBuy: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btAddMoneyClick(Sender: TObject);
    procedure btCancelPurchaseClick(Sender: TObject);
    procedure btBuyClick(Sender: TObject);
  private
    { Private declarations }
    dict: TDictionary;
  public
    { Public declarations }

    procedure UpdateTotalAmount;
    function GetTotalAmount: Integer;
    procedure NewPurchase;
    procedure UpdateChangeDetails(aAmount: Integer);

  end;

const
  CENT = 'cent';
  DOLLAR = 'dollar';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
dict.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
dict := TDictionary.Create;
end;

procedure TForm1.btAddMoneyClick(Sender: TObject);
var
 reName: TRegExpr;
 reValue: TRegExpr;
 mValue: Integer;
begin

reName := TRegExpr.Create;
reName.ModifierI := true;
reName.Expression := '(cent)|(dollar)+';

reValue := TRegExpr.Create;
reValue.Expression := '[0-9]+';

mValue := 0;
if reName.Exec(rgMoneySelector.Items[rgMoneySelector.ItemIndex]) then
 if reValue.Exec(rgMoneySelector.Items[rgMoneySelector.ItemIndex]) then
  begin
    if StrLower(PAnsiChar(reName.Match[0])) = CENT then
     begin
      try
       mValue := StrToInt(reValue.Match[0]);
      except
       mValue := 0;
      end;
     end
    else if StrLower(PAnsiChar(reName.Match[0])) = DOLLAR then
     begin
      try
       mValue := StrToInt(reValue.Match[0]) * 100;
      except
       mValue := 0;
      end;
     end;

    dict.AddKey(StrLower(PAnsiChar(reName.Match[0])), mValue);
    lMoneyStack.Items.Add(Format('$%n', [mValue / 100]));
  end;

UpdateTotalAmount;
end;

procedure TForm1.btCancelPurchaseClick(Sender: TObject);
begin
  NewPurchase;
end;

procedure TForm1.btBuyClick(Sender: TObject);
var
 reValue: TRegExpr;
 val_cost: Integer;
 val_total: Integer;
 val_change: Integer;
 fmt: TFormatSettings;
begin
val_change := 0;
reValue := TRegExpr.Create;
reValue.Expression := '[0-9]+\.[0-9]+';

fmt.ThousandSeparator := ',';
fmt.DecimalSeparator := '.';
if reValue.Exec(rgProductSelector.Items[rgProductSelector.ItemIndex]) then
 begin
  try
   val_cost := Trunc(StrToFloat(reValue.Match[0], fmt) * 100);
  except
   val_cost := 0;
  end;

  val_total := GetTotalAmount;

  if val_total < val_cost then
   begin
    MessageBox(0, 'Add money to buy the item.', 'Warning', MB_OK);
    exit;
   end;

  val_change := val_total - val_cost;
 end;

lbTotalChange.Caption := Format('Total change: $%n', [val_change / 100]);

//Change details...
UpdateChangeDetails(val_change);

NewPurchase;
end;

procedure TForm1.UpdateTotalAmount;
begin
 lbTotalAmount.Caption := Format('Total amount: $%n', [GetTotalAmount / 100]);
end;

function TForm1.GetTotalAmount: Integer;
var
 it: TDictionaryIterator;
 itm: TItemDictionary;
 val: Integer;
begin
val := 0;
it := dict.GetIterator;
while it.Next <> nil do
 begin
  itm := it.currItem;
  val := val + itm.KeyValue;
 end;
Result := val;
end;

procedure TForm1.NewPurchase;
begin
  lMoneyStack.Items.Clear;
  dict.Clear;
end;

procedure TForm1.UpdateChangeDetails(aAmount: Integer);
var
 am: Integer;
begin
am := aAmount;
lChange.Clear;

while am > 0 do
 begin

  if (am mod 200 >= 0) and (am >= 200) then
   begin
    am := am - 200;
    lChange.Items.Add('2 dollars');
   end
  else if (am mod 100 >= 0) and (am >= 100) then
   begin
    am := am - 100;
    lChange.Items.Add('1 dollar');
   end
  else if (am mod 50 >= 0) and (am >= 50) then
   begin
    am := am - 50;
    lChange.Items.Add('50 cents');
   end
  else if (am mod 20 >= 0) and (am >= 20) then
   begin
    am := am - 20;
    lChange.Items.Add('20 cents');
   end
  else if (am mod 10 >= 0) and (am >= 10) then
   begin
    am := am - 10;
    lChange.Items.Add('10 cents');
   end
  else if (am mod 5 >= 0) and (am >= 5) then
   begin
    am := am - 5;
    lChange.Items.Add('5 cents');
   end
  else
   begin
    lChange.Items.Add(IntToStr(am) + ' cents');
    am := 0;
   end;
 end;
end;

end.
