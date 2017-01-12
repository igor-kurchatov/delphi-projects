unit uGenerics;

interface

uses SysUtils, Contnrs, Variants;

type

  TValueDictionary = class(TObject)

    private
      FValueData: TVarData;

      procedure SetValue(aValue: Variant);
      function GetValue: Variant;


    public
      constructor Create; overload;
      constructor Create(aValue: Variant); overload;
      destructor Destroy; override;

      property Value: Variant read GetValue write SetValue;


  end;

  TItemDictionary = class(TObject)

    private
      FKeyName: ShortString;
      FKeyValue: TValueDictionary;


      function GetKeyValue: Variant;
      procedure SetKeyValue(aKeyValue: Variant);
    public
      constructor Create;
      destructor Destroy; override;

      property KeyName: ShortString read FKeyName;
      property KeyValue: Variant read GetKeyValue write SetKeyValue;

  end;

  TItemDictionaryArr = array of TItemDictionary;

  TItemsDictionary = class(TObjectList)


    protected
      function GetItem(Index: Integer): TItemDictionary;
      procedure SetItem(Index: Integer; AObject: TItemDictionary);

    public
      constructor Create;

      function Add(AObject: TItemDictionary): Integer;
      function Extract(Item: TItemDictionary): TItemDictionary;
      function Remove(AObject: TItemDictionary): Integer;
      function IndexOf(AObject: TItemDictionary): Integer;
      procedure Insert(Index: Integer; AObject: TItemDictionary);
      function First: TItemDictionary;
      function Last: TItemDictionary;
      property Items[Index: Integer]: TItemDictionary read GetItem write SetItem; default;


  end;


  TDictionaryIterator = class(TObject)

    private
      fDictItems: TItemsDictionary;
      Index: Integer;

      function GetFirstItem: TItemDictionary;
      function GetLastItem: TItemDictionary;
      function GetNextItem: TItemDictionary;
      function GetPrevItem: TItemDictionary;
      function GetCurrItem: TItemDictionary;

    public
      constructor Create(aDictItems: TItemsDictionary);
      destructor Destroy; override;

      procedure Reset;
      function Next: TItemDictionary;
      function Previous: TItemDictionary;


      property firstItem: TItemDictionary read GetFirstItem;
      property lastItem: TItemDictionary read GetLastItem;
      property nextItem: TItemDictionary read GetNextItem;
      property prevItem: TItemDictionary read GetPrevItem;
      property currItem: TItemDictionary read GetCurrItem;

  end;


  TDictionary = class(TObject)

    private
      FDictionaryItems: TItemsDictionary;
      FIteratorList: TObjectList;

    public
      constructor Create;
      destructor Destroy; override;

      procedure AddKey(aKeyName: ShortString; aValue: Variant); overload;
      procedure AddKey(aKeyName: ShortString); overload;
      procedure Clear;

      function GetIterator: TDictionaryIterator;

      //function FindItemByKeyName(const aKeyName: ShortString): TItemDictionaryArr;

  end;

implementation

//uses VarUtils;

{ TDictionary }

procedure TDictionary.AddKey(aKeyName: ShortString; aValue: Variant);
var
 dItem: TItemDictionary;
begin
 FIteratorList.Clear;
 dItem := TItemDictionary.Create;
 dItem.FKeyName := aKeyName;
 dItem.KeyValue := aValue;
 FDictionaryItems.Add(dItem);
end;

procedure TDictionary.AddKey(aKeyName: ShortString);
var
 dItem: TItemDictionary;
begin
 FIteratorList.Clear;
 dItem := TItemDictionary.Create;
 dItem.FKeyName := aKeyName;
 FDictionaryItems.Add(dItem);
end;

procedure TDictionary.Clear;
begin
FIteratorList.Clear;
FDictionaryItems.Clear;
end;

constructor TDictionary.Create;
begin
  FDictionaryItems := TItemsDictionary.Create;
  FIteratorList := TObjectList.Create;
end;

destructor TDictionary.Destroy;
begin
  FIteratorList.Free;
  FDictionaryItems.Free;
  inherited;
end;

function TDictionary.GetIterator: TDictionaryIterator;
var
 iter: TDictionaryIterator;
begin
  iter := TDictionaryIterator.Create(FDictionaryItems);
  FIteratorList.Add(iter);
  Result := iter;
end;

{ TItemDictionary }

constructor TItemDictionary.Create;
begin
FKeyName := '';
FKeyValue := TValueDictionary.Create;
end;

destructor TItemDictionary.Destroy;
begin
  FKeyValue.Free;
  inherited;
end;

{ TValueDictionary }

constructor TValueDictionary.Create;
begin
  FValueData.VType := varEmpty;
end;

constructor TValueDictionary.Create(aValue: Variant);
begin
  Self.Create;
  Value := aValue;
end;

destructor TValueDictionary.Destroy;
begin
  inherited;
end;

function TValueDictionary.GetValue: Variant;
begin

case FValueData.VType of
  varEmpty: Result := Unassigned;
  varNull: Result := Null;
  varSmallint: Result := FValueData.VSmallInt;
  varInteger: Result := FValueData.VInteger;
  varSingle: Result := FValueData.VSingle;
  varDouble: Result := FValueData.VDouble;
  varCurrency: Result := FValueData.VCurrency;
  varDate: Result := FValueData.VDate;
  varOleStr: Result := OleStrToString(FValueData.VOleStr);
  varDispatch: Result := PVariant(FValueData.VDispatch)^;
  varError: Result := FValueData.VError;
  varBoolean: Result := FValueData.VBoolean;
  //varVariant: Result := Variant(FValueData);
  varUnknown: Result := PVariant(FValueData.VUnknown)^;
  varShortInt: Result := FValueData.VShortInt;
  varByte: Result := FValueData.VByte;
  varWord: Result := FValueData.VWord;
  varLongWord: Result := FValueData.VLongWord;
  varInt64: Result := FValueData.VInt64;
  //varStrArg: Result := FValueData.VBoolean;
  varString: Result := PVariant(FValueData.VString)^;
  varAny: Result := PVariant(FValueData.VAny)^;
  //varTypeMask
  varArray: Result := PVariant(FValueData.VArray)^;
  varByRef: Result := PVariant(FValueData.VPointer)^;
else
  Result := Unassigned;
end;

end;

procedure TValueDictionary.SetValue(aValue: Variant);
begin

try
  FValueData := TVarData(aValue);
except
  FValueData.VType:= varEmpty;
end;

end;

{ TItemsDictionary }

function TItemsDictionary.Add(AObject: TItemDictionary): Integer;
begin
  Result := inherited Add(AObject);
end;

constructor TItemsDictionary.Create;
begin
inherited Create;
end;

function TItemsDictionary.Extract(Item: TItemDictionary): TItemDictionary;
begin
  Result := TItemDictionary(inherited Extract(Item));
end;

function TItemsDictionary.First: TItemDictionary;
begin
  Result := TItemDictionary(inherited First);
end;

function TItemsDictionary.GetItem(Index: Integer): TItemDictionary;
begin
 Result := TItemDictionary(inherited GetItem(Index));
end;

function TItemsDictionary.IndexOf(AObject: TItemDictionary): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TItemsDictionary.Insert(Index: Integer;
  AObject: TItemDictionary);
begin
 inherited Insert(Index, AObject);
end;

function TItemsDictionary.Last: TItemDictionary;
begin
  Result := TItemDictionary(inherited Last);
end;

function TItemsDictionary.Remove(AObject: TItemDictionary): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TItemsDictionary.SetItem(Index: Integer;
  AObject: TItemDictionary);
begin
  inherited SetItem(Index, AObject);
end;

function TItemDictionary.GetKeyValue: Variant;
begin
  Result := FKeyValue.Value;
end;

procedure TItemDictionary.SetKeyValue(aKeyValue: Variant);
begin
 FKeyValue.Value := aKeyValue;
end;

{ TDictionaryIterator }

constructor TDictionaryIterator.Create(aDictItems: TItemsDictionary);
begin
  fDictItems := aDictItems;
  Index := -1;
end;

destructor TDictionaryIterator.Destroy;
begin
  inherited;
end;

function TDictionaryIterator.GetCurrItem: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  if (Index >= 0) then
    Result := fDictItems.Items[Index];
end;

function TDictionaryIterator.GetFirstItem: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  Result := fDictItems.First;
end;

function TDictionaryIterator.GetLastItem: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  Result := fDictItems.Last;
end;

function TDictionaryIterator.GetNextItem: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  if fDictItems.Count - 1 >= Index + 1 then
    Result := fDictItems.Items[Index + 1];
end;

function TDictionaryIterator.GetPrevItem: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  if ( (Index - 1 >= 0) and (fDictItems.Count > Index - 1) ) then
    Result := fDictItems.Items[Index - 1];
end;

function TDictionaryIterator.Next: TItemDictionary;
var
 itm: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  if fDictItems.Count - 1 >= Index + 1 then
   begin
    Inc(Index);
    itm := fDictItems.Items[Index];

    //if (itm.KeyName <> groupByKey) and (groupByKey <> '') then
    //  itm := nil;

    //if itm <> nil then
    //  if (itm.KeyValue <> groupByValue) and (not VarIsEmpty(groupByValue)) then
    //    itm := nil;

    Result := itm;
   end
  else
    Index := -1;
end;

function TDictionaryIterator.Previous: TItemDictionary;
begin
Result := nil;
if fDictItems <> nil then
  if ( (Index - 1 >= 0) and (fDictItems.Count > Index - 1) ) then
   begin
    Dec(Index);
    Result := fDictItems.Items[Index];
   end
  else
    Index := -1;
end;

procedure TDictionaryIterator.Reset;
begin
  Index := -1;
end;

end.
