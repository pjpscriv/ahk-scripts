#Requires AutoHotkey v2.0
#SingleInstance Force

; Accents
:?*:a/::á
:?*:e/::é
:?*:i/::í
:?*:o/::ó
:?*:u/::ú

:?*:A/::Á
:?*:E/::É
:?*:I/::Í
:?*:O/::Ó
:?*:U/::Ú

; Graves
:?*:a\::à
:?*:e\::è
:?*:i\::ì
:?*:o\::ò
:?*:u\::ù

:?*:A\::À
:?*:E\::È
:?*:I\::Ì
:?*:O\::Ò
:?*:U\::Ù

; Accent / Grave escaping
^/::Send "{Raw}/"
^\::Send "{Raw}\"

; Circumflexes
:?*:a^::â
:?*:e^::ê
:?*:i^::î
:?*:o^::ô
:?*:u^::û

:?*:A^::Â
:?*:E^::Ê
:?*:I^::Î
:?*:O^::Ô
:?*:U^::Û

; Diaeresis
; You can't see it, but there's a invisible combining diaeresis here - https://symbl.cc/en/0308/
^;::Send "̈" 

; Macrons
:?*:a|::ā
:?*:e|::ē
:?*:i|::ī
:?*:o|::ō
:?*:u|::ū

:?*:A|::Ā
:?*:E|::Ē
:?*:I|::Ī
:?*:O|::Ō
:?*:U|::Ū

; Cedille
:?*:c`:::ç
:?*:C`:::Ç

; Spanish n
:?*:n~::ñ
:?*:N~::Ñ

; Combined characters
:?*:oe)::œ
:?*:OE)::Œ
:?*:ae)::æ
:?*:AE)::Æ

; Quote marks - Guillemets
:?*:<<::«
:?*:>>::»
