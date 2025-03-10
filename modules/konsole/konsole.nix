{ pkgs, lib, ... }:
let
  johnProfile = pkgs.writeText "john.profile" ''
    [Appearance]
    ColorScheme=gruvbox
    Font=SauceCodePro Nerd Font,14,-1,5,50,0,0,0,0,0
    TabColor=27,30,32,0
    
    [Cursor Options]
    UseCustomCursorColor=true
    
    [General]
    LocalTabTitleFormat=Terminal
    Name=john
    Parent=FALLBACK/
    
    [Interaction Options]
    AutoCopySelectedText=true
    MiddleClickPasteMode=1
    TextEditorCmd=6
    TextEditorCmdCustom=vim
    
    [Scrolling]
    HistorySize=10000
  '';

  gruvboxColorScheme = pkgs.writeText "gruvbox.colorscheme" ''
    [Background]
    Color=29,32,33
    
    [BackgroundFaint]
    Color=29,32,33
    
    [BackgroundIntense]
    Color=29,32,33
    
    [Color0]
    Color=60,56,54
    
    [Color0Faint]
    Color=60,56,54
    
    [Color0Intense]
    Color=60,56,54
    
    [Color1]
    Color=234,105,98
    
    [Color1Faint]
    Color=234,105,98
    
    [Color1Intense]
    Color=234,105,98
    
    [Color2]
    Color=169,182,101
    
    [Color2Faint]
    Color=169,182,101
    
    [Color2Intense]
    Color=169,182,101
    
    [Color3]
    Color=216,166,87
    
    [Color3Faint]
    Color=216,166,87
    
    [Color3Intense]
    Color=216,166,87
    
    [Color4]
    Color=125,174,163
    
    [Color4Faint]
    Color=125,174,163
    
    [Color4Intense]
    Color=125,174,163
    
    [Color5]
    Color=211,134,155
    
    [Color5Faint]
    Color=211,134,155
    
    [Color5Intense]
    Color=211,134,155
    
    [Color6]
    Color=137,180,130
    
    [Color6Faint]
    Color=137,180,130
    
    [Color6Intense]
    Color=137,180,130
    
    [Color7]
    Color=212,190,152
    
    [Color7Faint]
    Color=212,190,152
    
    [Color7Intense]
    Color=212,190,152
    
    [Foreground]
    Color=212,190,152
    
    [ForegroundFaint]
    Color=212,190,152
    
    [ForegroundIntense]
    Color=212,190,152
    
    [General]
    Blur=false
    ColorRandomization=false
    Description=Gruvbox Material Hard Dark
    Opacity=1
    Wallpaper=
  '';
in
{
  home.file.".local/share/konsole/john.profile".source = johnProfile;
  home.file.".local/share/konsole/gruvbox.colorscheme".source = gruvboxColorScheme;
}

