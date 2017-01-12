object Form1: TForm1
  Left = 455
  Top = 173
  Width = 587
  Height = 439
  Caption = 'Cofee Machine'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object rgMoneySelector: TRadioGroup
    Left = 8
    Top = 16
    Width = 257
    Height = 137
    Caption = 'Money'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '5 cents'
      '10 cents'
      '20 cents'
      '50 cents'
      '1 dollar'
      '2 dollars')
    TabOrder = 0
  end
  object lMoneyStack: TListBox
    Left = 376
    Top = 24
    Width = 177
    Height = 129
    ItemHeight = 16
    TabOrder = 1
  end
  object btAddMoney: TButton
    Left = 280
    Top = 56
    Width = 75
    Height = 25
    Caption = '-->'
    TabOrder = 2
    OnClick = btAddMoneyClick
  end
  object btCancelPurchase: TButton
    Left = 280
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btCancelPurchaseClick
  end
  object Product: TGroupBox
    Left = 8
    Top = 176
    Width = 545
    Height = 201
    Caption = 'Coffee machine'
    TabOrder = 4
    object lbTotalAmount: TLabel
      Left = 16
      Top = 24
      Width = 81
      Height = 16
      Caption = 'Total amount:'
    end
    object Label1: TLabel
      Left = 16
      Top = 56
      Width = 93
      Height = 16
      Caption = 'Change details:'
    end
    object lbTotalChange: TLabel
      Left = 152
      Top = 24
      Width = 82
      Height = 16
      Caption = 'Total change:'
    end
    object rgProductSelector: TRadioGroup
      Left = 152
      Top = 56
      Width = 377
      Height = 129
      Caption = 'Choose product'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Cappuccino.....$3.50'
        'Latte...................$3.00'
        'Decaf.................$4.00'
        'Black Tea........$1.50'
        'Green Tea.......$1.00')
      TabOrder = 0
    end
    object lChange: TListBox
      Left = 16
      Top = 72
      Width = 121
      Height = 113
      ItemHeight = 16
      TabOrder = 1
    end
    object btBuy: TButton
      Left = 440
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Buy'
      TabOrder = 2
      OnClick = btBuyClick
    end
  end
end
