--[[---------------------------------------------------------------------------
--------------------------------- DESCRIPTION ---------------------------------
Fontbox version 1.1
Copyright Torben Ratzlaff
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


With this module you can create text fields, wihch offer several formating options. 
These are:

- Manual line breaks
- Manual line spacing
- Left justified, right justified or centered text alignment
- Individual passages can be recolored, resized or underlined
- Write the entire text in uppercases
- Kerning and letter spacing

To use this module there you have to set four settings.

	1 Use the command fontbox = require ("fontbox"), at the start of your main.lua file.

	2 Special characters like ä ö ü ß á ó ú § $, and so on have to be loaded via the command fontbox.addSpecialCharacters. This function needs a table with the characters as string.
	Example: fontbox.addSpecialCharacters {"ä", "ö", "ü", "Ä", "Ö", "Ü", "ß"}

	3 If you use special characters and want to use the property 'Uppercase', you have to assign the lowercase characters with the corresponding uppercase characters. For this purpose use the function fontbox.addSpecialUppercase. Pass the function a table with sub tables that contain both the small and the capital letters.
	Example: {{fontbox.addSpecialUppercase "ä", "Ä"}, {"ö", "Ö"}, {"u", "T"}}

	4 If you want to use your own font, you have to load it via the command fontbox.newFontSet. You have to set following properties: A name for the fontset, the name of the font you want to use, a string that contains all characters contains want to use. You can add further declaration like letter spacing, kerning pairs, the undlerline thickness, the lineheight and the textspacing.


Then you can load a text box with the fontbox.newTextBox command. This function requires the name of the font set, the size of the font, the position of the box, the boxes width and height. And of course a string of text to be displayed. Additional settings are the font color, line spacing, character spacing, text alignment and the ability to present the text as uppercases.


Manual line breaks may be created over the <n /> tag . This can be placed anywhere within the text. Several <n /> tags in a row lead to blank lines.
	Example: This is a <n /> test text.


Individual passages may be specified by so-called spans (similar to HTML spans). The syntax
is the following:
		This is a test <span size={50}> set to explain</ span> spans.

	A span always starts with '<span Propertie={Value}> and ends with </ span>. The characters within the
	span now use the value specified for the property. Possible properties are:
		- size    		Change the text size of characters 					eg: {size = 50} 
		- color 		Changes the color of the text characters 			eg: color = {120,244,100}
		- style 		underlines the characters when set to underline		eg: style = {underline}

The values ​​must be in brackets!
Spans can also go over line breaks.

ATTENTION! Several spans may NOT be nested, this will lead to errors.


Use fontbox.newTextBox(props) to create a new textbox.

Has a text box been created the following features are available.

	yourTextbox:delete () 					- clears the text box, use yourTextbox = nil after this
	
	yourTextbox:reload () 					- loads the new text box, if necessary properties have changed
											  WARNING: may be performance-heavy
										  
	yourTextbox:changeProperty(props) 		- Changes the properties of the text box and reloads.
											  WARNING: may be performance-heavy
										  
	yourTextbox:showBackground ()			- Displays the dimensions of the text box to position it
	
	yourTextbox:hideBackground () 			- Hides the dimensions of the text box.

You can set the following properties for new fontsets:
	name						- the name you want to use to indicate this fontset
	font_name 					- the name of the  used font like you would use it in display.newText
	spacing						- the general character spacing
	char_width 					- the space before and after a specific character ["a"]={1, 0.8}
	all_letters 				- all letters used by this fontset
	underline_size 				- the tickness of the underline
	underline_height 			- the y position of the underline 
	kerning_pairs 				- the kerning pairs for the font set {letter1, letter2}
	
The properties you can set for new textboxes and for yourTextbox:changeProperty
	set_name 					- the name of the fontset you want to use
	x, y						- the upper left corner position of the textbox
	width, height				- the maximum width and height of the textbox
	align 						- the textalignment of the box ("left", "right", "center)
	line_height 				- the lineheight in realtion to the fontsize
	size						- the fontsize
	color						- the font color
	spacing						- the character spacing (leave out and it will use the porperties of the fontset)
	text						- the text displayed in the box
	uppercase					- set to true to write the whole text in uppercases


A text box is created is a display group and can be treated as one. You can use .isVisible .alpha and
:SetReferencePoint() on it. Furthermore, you can add touch or tap event listeners.


NOTE: The character μ can not be used as a normal character, because it is used in the internal string
processing. If it is still used, it leads to unexspected text behaviour.


Tips & Tricks:
	- If you generate a blank line by the double use of the </n> tags, you can set a span around the second</n> and change it's size. With this any desired lineheight is possible.
	(Negative values ​​are possible in this case too)

	- If you set the underline_height of the fontset to 0 you can strikethrough the text instead of underlining it.

	- Set the lineheight and the textspacing in relation to the font seize. For smaller text greater lineheight and textspacing increase the readability.

	- If you use a font which has only capital letters, you should set the property uppercase=true, because then you only have to balance the capital letters.

	- You can uses several spaces to create parenthesis





---------------------------------BESCHREIBUNG----------------------------------

Mit diesem Modul können Textfelder erstellt werden, die mehrere Formatierungen
zu Verfügung stellen. Diese sind:

- manuelle Zeilenumbrüche
- manueller Zeileabstand
- linksbündige, rechtsbündige oder zentrierte Textausrichtung
- einzelne Textpassagen können umgefärbt, in der Größe verändert oder unterstrichen werden
- den ganzen Text groß schreiben
- Kerning und Spationierung

Um dieses Modul nutzen zu können müssen zuerst vier Einstellungen vorgenommen werden.

1.	Benutze den Befehl fontbox=require("fontbox") , am besten zu Beginn deiner main.lua File.

2. 	Sepzielle Zeichen wie  ä ö ü á ó ú ß § $ usw. müssen über den Befehl fontbox.addSpecialCharacters 
	geladen werden. Dieser Funktion muss eine Tabelle mit den  entsprechende Zeichen als Strings 
	übergeben werden.
	Bsp: fontbox.addSpecialCharacters{"ä", "ö", "ü", "Ä", "Ö", "Ü", "ß"}
	
3.	Benutzt man spezielle Zeichen und will die Eigenschaft 'Uppercase' benutzen, so muss man den 
	entsprechenden Kleinbuchstaben die GroßBuchstaben zuweisen. Hierfür nutzt man die Funktion 
	fontbox.addSpecialUppercase. Man übergibt der Funktion eine Tabelle mit Untertabellen, die sowohl
	den Klein- als auch den Großbuchstaben beinhalten.
	Bsp: fontbox.addSpecialUppercase{{"ä", "Ä"},{"ö", "Ö"},{"ü", "Ü"}}
	
4.	Will man eine eigene Schrift benutzen, so muss man diese über den Befehl fontbox.newFontSet laden.
	Man gibt hierbei einen Namen für das fontset und den Namen der Schrift an, des weiteren einen String der alle Zeichen enthält die man benutzen will. Es können weitere Einstellungen vorgenommen werden, wie Spationierung, Kerningpaare, dicke der Linie beim unterstreichen, Höhe der Linie beim Unterstreichen und die Laufweite der Schrift.
	

Anschließend kann man über den Befehl fontbox.newTextBox ein Textfeld laden. Diese Funktion benötigt de Namen des fontsets, die größe der Schrift, die Position der Box, die Breite und die Höhe. Des weiteren natürlich einen String des Textes der angezeigt werden soll. weitere Einstellungsmöglichkeiten sind die Schriftfarbe, der Zeilenabstand, die Laufweite, die Textausrichtung und die Möglichkeit den Text komplett groß zu schreiben.


Manuelle Zeilenumbrüche können über den Tag </n> erzeugt werden. Dieses kann überall innerhalb des Textes
platziert werden. Mehrere </n> Tags hintereinander führen zu Leerzeilen.
	Bsp: Dies ist ein </n>Testtext.
	

Einzelne Textpassagen können über sogenannte Spans (ähnlich HTML spans) spezifiziert werden. Die Syntax 
ist dabei folgende:
			Die ist ein Test<span size={50}>satz um die Wirkungsweise von Spans</span> zu erläutern.
			
	Ein span startet immer mit '<span  Eigenschaft={Wert}  > und endet mit </span>. Die Zeichen innerhalb 
	Spans nutzen nun den für die spezielle Eingeschaft angegebenen Wert. Mögliche Eigenschaften sind:
		- size			Ändert die Textgröße der Zeichen			Bsp: size={50}
		- color			Ändert die Textfarbe der Zeichen			Bsp: color={120,244,100}
		- style			unterstreicht die Zeichen wenn underline	Bsp: style={underline}
		
	Die Werte müssen dabei in geschwungenen Klammern stehen!
	Span können auch über Zeilenumbrüche hinweggehen.
	
	ACHTUNG! Mehrere Spans dürfen NICHT ineinander verschachtelt sein, dies fürht zu Fehlern.

Erstelle ein neue textbox mit fontbox.newTextBox(props)

Für eine erstellte Textbox stehen folgende Funktionen zur Auswahl.

yourTextbox:delete()				-	löscht die Textbox, diese wollte danach noch =nil gesetzt werden
yourTextbox:reload()				-	lädt die Textbox neu, notwendig wenn Eigenschaften geändert wurden
										ACHTUNG!: kann Performance-Lastig sein
yourTextbox:changeProperty(props)	-	Ändert die tabellarisch angegebenen Eigenschaften der Textbox 	
										und lädt diese neu. ACHTUNG!: kann Performance-Lastig sein
yourTextbox:showBackground()		-	Zeigt die Abmaße der Textbox an um diese besser positionieren 
										zu können
yourTextbox:hideBackground()		-	Macht die Abmaße der Textbox wieder unsichtbar.

										
Folgende Einstellungen können für fontsets gestzt werden:
	name						- der Name mit dem das fontset identifiziert werden soll
	font_name 					- der Name der benutzten Schrift wie bei display.newText
	spacing						- die generelle Laufweite
	char_width 					- der Abstand vor und hinter jeden einzelnen Buchstaben ["a"]={1, 0.8}
	all_letters 				- alle Buchstaben die dieses Fonstset benutzt
	underline_size 				- die Dicke der Linie zum Unterstreichen
	underline_height 			- die Höhe der Linie
	kerning_pairs 				- Kerning-Paare für dieses Fontset {letter1, letter2}
	
Diese Eigenschaften können für neue Textboxen und yourTextbox:changeProperty benutzt werden
	set_name 					- der Name des Fontsets das benutzt werden soll
	x, y						- die Position der linken oberen Ecke der Textbox
	width, height				- die Breite und Höhe der Textbox
	align 						- Textausrichtung ("left", "right", "center)
	line_height 				- der Zeilenabstand in relation zur Schriftgröße
	size						- die Schriftgröße
	color						- die Schriftfarbe
	spacing						- der Abstand vor und nach einem Buchstaben (auslassen um die Einstellungen des Fontsets zu nutzen)
	text						- der Text der angezeigt werden soll
	uppercase					- auf true setzen um den gesammten Text groß zu schreiben

				
Eine erstellte Textbox ist eine DisplayGroup und kann somit die Befehle .isVisible .alpha und 
:setReferencePoint() nutzen. Desweiteren kann ihr ein Tocuh oder Tap Eventlistener angefügt werden.


WICHTIG!: 	Das Zeichen µ kann nicht als normales Zeichen verwendet werden, da es für die interne String-
			verarbeitung genutzt wird. Wird es dennoch genutzt führt es zu einem Zeilenumbruch und einem
			undefinierten Zeichen.
			
			
Tips & Tricks:
	- Wenn man durch die doppelte Anwendung des </n> Tags eine Leerzeile erzeugt, kann man um das zweite
	  </n> einen Span legen der eine andere Größe definiert. So ist es möglich Zeilenabstände beliebiger
	  Größe zu generieren. (auch negative Größen sind in diesem Fall möglich)
	  
	- Wenn man die underline_height des Fontsets auf 0 setzt so kann man mit dem underline Befehl nun
	  text durchstreichen statt ihn zu unterstreichen.
	  
	- Der Zeilenabstand und die Laufweite des Textes sollten sich nach der angezeigten Textgröße und der 
	  ausgewählten Schriftart richten. Bei kleineren Texten erhöht eine größere Laufweite die Lesbarkeit.

	- Sollte man eine Schrift benutzen die nur Großbuchstaben besitzt, so sollte man die Eigenschaft
	  uppercase=true setzen, da man dann nur für die Großbuchstaben einen ausgleich vornehmen muss.
	  
	- Es können mehrere Freizeichen hintereinander benutzt werden um Einschübe darzustellen

-------------------------------------------------------------------------------
-----------------------------------------------------------------------------]]


local fontbox = {}

fontbox.fonts = {}


local slength = string.len
local ssub = string.sub
local sgsub = string.gsub
local sfind = string.find
local stonumber = tonumber
local tinsert = table.insert
local floor = math.floor
local ceil = math.ceil


local special_chars = {	[ssub("ä",2,2)]="ä",
						[ssub("ö",2,2)]="ö",
						[ssub("ü",2,2)]="ü",
						[ssub("Ä",2,2)]="Ä",
						[ssub("Ö",2,2)]="Ö",
						[ssub("Ü",2,2)]="Ü",
						[ssub("ß",2,2)]="ß",
						["pre"]=ssub("ä",1,1),
						["nl"]=ssub("µ",2,2)}
						
local special_uppercase = {	["ä"] = "Ä",
							["ö"] = "Ö",
							["ü"] = "Ü",}

local standard_char_width = {	["a"]={1, 1},
								["b"]={1, 1},
								["c"]={1, 1},
								["d"]={1, 1},
								["e"]={1, 1},
								["f"]={1, 1},
								["g"]={1, 1},
								["h"]={1, 1},
								["i"]={1, 1},
								["j"]={1, 1},
								["k"]={1, 1},
								["l"]={1, 1},
								["m"]={1, 1},
								["n"]={1, 1},
								["o"]={1, 1},
								["p"]={1, 1},
								["q"]={1, 1},
								["r"]={1, 1},
								["s"]={1, 1},
								["t"]={1, 1},
								["u"]={1, 1},
								["v"]={1, 1},
								["w"]={1, 1},
								["x"]={1, 1},
								["y"]={1, 1},
								["z"]={1, 1},
								["ß"]={1, 1},
								["A"]={1, 1},
								["B"]={1, 1},
								["C"]={1, 1},
								["D"]={1, 1},
								["E"]={1, 1},
								["F"]={1, 1},
								["G"]={1, 1},
								["H"]={1, 1},
								["I"]={1, 1},
								["J"]={1, 1},
								["K"]={1, 1},
								["L"]={1, 1},
								["M"]={1, 1},
								["N"]={1, 1},
								["O"]={1, 1},
								["P"]={1, 1},
								["Q"]={1, 1},
								["R"]={1, 1},
								["S"]={1, 1},
								["T"]={1, 1},
								["U"]={1, 1},
								["V"]={1, 1},
								["W"]={1, 1},
								["X"]={1, 1},
								["Y"]={1, 1},
								["Z"]={1, 1},
								[" "]={1, 1},
								["."]={1, 1},
								[","]={1, 1},
								["?"]={1, 1},
								["!"]={1, 1},
								["-"]={1, 1},
								[":"]={1, 1},
								[";"]={1, 1},
								["_"]={1, 1},
								["+"]={1, 1},
								["/"]={1, 1},
								["("]={1, 1},
								[")"]={1, 1},
								["&"]={1, 1},
								["%"]={1, 1},
								["'"]={1, 1},
								["<"]={1, 1},
								[">"]={1, 1},
								["|"]={1, 1},
								}
								
local standard_all_letters = "abcdefghijklmnopqrstuvwxyzßABCDEFGHIJKLMNOPQRSTUVWXYZ .,?!-:;_+/()&%'<>|"

local function stringToTable(s)
  s = s .. ','
  local t = {}
  local fieldstart = 1
  repeat
    if sfind(s, '^"', fieldstart) then
      local a, c
      local i  = fieldstart
	  
      repeat
        a, i, c = sfind(s, '"("?)', i+1)
      until c ~= '"'
      if not i then error('unmatched "') end
      local f = ssub(s, fieldstart+1, i-1)
      tinsert(t, (sgsub(f, '""', '"')))
      fieldstart = sfind(s, ',', i) + 1
    else
      local nexti = sfind(s, ',', fieldstart)
      tinsert(t, ssub(s, fieldstart, nexti-1))
      fieldstart = nexti + 1
    end
  until fieldstart > slength(s)
  return t
end


local function setUpperCase(s)
	if special_uppercase[s] then
		s = special_uppercase[s]
	else
		s = string.upper(s)
	end
	
	return s
end


function fontbox.newFontSet(arg)
	local font_set = {}
	local name = arg.name or "test"
	font_set.font_name = arg.font_name or nativeSystemFont
	font_set.spacing = arg.spacing or 0.05
	font_set.char_width = arg.char_width or standard_char_width
	font_set.all_letters = arg.all_letters or standard_all_letters
	font_set.underline_size = arg.underline_size or 0.08
	font_set.underline_height = arg.underline_height or 0.5
	font_set.letter_ratios = arg.letter_ratios
	font_set.kerning_pairs = arg.kerning_pairs or {}
	
	if not font_set.letter_ratios then
		font_set.letter_ratios = {}
		local all_letters = font_set.all_letters

		local font_size = 500
		local letterbox = display.newText("", 0, 0, font_set.font_name, font_size)
		letterbox.anchorX, letterbox.anchorY = 0.5, 0.5
		for i=1, slength( all_letters ) do
			local char = all_letters:sub( i , i )

			if char ~= special_chars["pre"] then
				if special_chars[char] then 
					char = special_chars[char]
				end 

				letterbox.text = char
				local letter_width = letterbox.width

				local ratio = letter_width/font_size
				if char == " " then ratio = 0.3 end
				font_set.letter_ratios[char]=ratio
			end
		end

		letterbox:removeSelf()
		letterbox=nil
	end
	
	fontbox.fonts[name] = font_set
	return font_set
end


function fontbox.newTextBox(arg)
	local font_set_name = arg.set_name
	local font_set = fontbox.fonts[font_set_name]
	
	-- changeable properties
	local box_x, box_y = arg.x or 0, arg.y or 0
	local width, height = arg.width or 300, arg.height or 500
	local text_align = arg.align or "left"
	local line_height = arg.line_height or 1.2
	local font_size = arg.size or 35
	local font_color = arg.color or {0,0,0}
	local spacing = arg.spacing or font_set.spacing
	local text = arg.text or ""
	local uppercase = arg.uppercase or false
	
	-- fixed properties
	local font_name = font_set.font_name or nativeSystemFont
	local char_width = font_set.char_width
	local all_letters = font_set.all_letters
	local kerning_pairs = font_set.kerning_pairs
	local letter_ratios = font_set.letter_ratios
	local underline_size = font_set.underline_size
	local underline_height = font_set.underline_height
	
	
	local textbox = display.newGroup()
	textbox.x, textbox.y = box_x, box_y
	textbox.box_width, textbox.box_height = width, height
	textbox.text_align = text_align
	textbox.line_height = line_height
	textbox.font_size = font_size
	textbox.font_color = font_color
	textbox.spacing = spacing
	textbox.text = text
	textbox.uppercase = uppercase
	
	local bgbox = display.newRect(0, 0, width, height)
	bgbox.anchorX, bgbox.anchorY = 0, 0
	bgbox.x, bgbox.y = 0, 0
	bgbox:setFillColor(0.4,0.4,0.4)
	textbox:insert(bgbox)
	bgbox.isVisible = false
	

	textbox.lines = {}
	textbox.spans = {}
	textbox.words = {}
	
	local span_calls = 1
	local create_line, separate_words, separate_spans, create_text
	
	create_line = function()
		local lines = textbox.lines
		local line_height = textbox.line_height
		local text_align = textbox.text_align
		
		local line = display.newGroup()
		textbox:insert(line)
		line.num = #lines+1
		lines[line.num] = line
		line.lineLength = 0
		line.max_size = 0
		
		return line
	end

	
	separate_spans = function(s, props)
		local span_s, span_e = sfind(s, "<span")
		
		--existiert ein <span> Tag?
		if span_s then
			span_calls = 0
			
			--steht der Span nicht direkt zu Beginn des Strings?
			if span_s > 1 then
				--füge den Teil vor dem Span in die Tabelle ein, gib den Rest zurück an die Funktion
				local string_before = ssub(s, 1, span_s-1)
				local string_after = ssub(s, span_s)
				textbox.spans[#textbox.spans+1] = { string_before , props }
				
				separate_spans(string_after)
				
			else
				--Ermittle die Ausmaße und die Eingeschaften des Span Starts
				local span_start_first, span_start_last = 1, 4
				local span_start_final = sfind(s, ">", span_start_last+1)
				local span_props_s, span_props_e = span_start_last+2, span_start_final-1
				local span_props_string = ssub(s, span_props_s, span_props_e)
				local span_props = {}
				
				--Durchsucht den Propertie Span nach der gegebenen Eigenschaft
				local function find_prop(name)
					local prop_is_first, prop_is_last = sfind(span_props_string, name)
					
					--gibt es die gesuchte Propertie
					if prop_is_first then
						local prop_start = sfind(span_props_string, "{", prop_is_last+1, prop_is_last+5)+1
						local prop_end = sfind(span_props_string, "}", prop_start)-1
						
						local prop_string = ssub(span_props_string, prop_start, prop_end)
						local prop 
						
						if name == "color" then
							prop = stringToTable(prop_string)
						elseif name == "size" then
							prop = stonumber(prop_string)
						elseif name == "style" then
							prop = prop_string
						end
						
						span_props[name]=prop
					end
				end
				
				find_prop("color")
				find_prop("size")
				find_prop("style")
				
				local span_end_first, span_end_last = sfind(s, "</span>", span_start_final+1)
				
				--gibt es ein Span Ende?
				if span_end_first then
					--befindet sich ein Inhalt ziwschen span Anfang und Ende
					if span_start_final-span_end_first == 1 then
						local string_after = ssub(s, span_end_last+1)
					
						--gib den Rest nach dem Span zurück
						separate_spans(string_after)
						
					else
						local string_inside = ssub(s, span_start_final+1, span_end_first-1)
						local string_after = ssub(s, span_end_last+1)
						
						--gib den Inhalt zwischen den beiden Spans mit Properties und den Rest nach dem Span zurück
						separate_spans(string_inside, span_props)
						
						if slength(string_after) > 0 then
							separate_spans(string_after)
						else
							separate_spans("</end>")
						end
					end
				
				else
					local string_after = ssub(s, span_start_final+1)
					--gib den gesammten String nach dem ersten Span Tag mit Properties zurück
					separate_spans(string_after, span_props)
				end
			
			end
		else
			--Es existiert im gegebenen String kein span Tag
			span_calls = span_calls + 1
			
			if s ~= "</end>" then
				--trag den String in die Tabelle ein
				textbox.spans[#textbox.spans+1] = { s , props}
			end
		 
			--wurde dieser Abschnitt 2mal hintereinander aufgerufen? Dann ist hier Ende
			if span_calls == 2 then
				span_calls = 1
			
				separate_words()
			end
		end
	end
	

	separate_words = function()
		local word = {}
		local spans = textbox.spans
		local words = textbox.words
		
		--gehe jeden Span einzeln durch
		for i=1, #spans do
			local span = spans[i]
			local char_string = span[1]
			local props = span[2] or {}
			
			--checken ob sich span ein </n> Befehl befindet und diesen ersetzen
			local nl = sfind(char_string, "</n>")
			if nl then
				char_string = sgsub(char_string, "</n>", special_chars["nl"])
			end
			
			local char_string_len = slength(char_string)
			--gehe jedes Zeichen des Strings durch
			for j=1, char_string_len do
				local char = char_string:sub( j , j )
				--ist das Zeichen ein Freizeichen?
				if char == " " then
					--besitzt das aktuelle Wort Zeichen? Wenn ja, speicher sie und setze das Wort zurück
					if #word > 0 then
						words[#words+1] = word
					
						word={}
					end
					
					--speichere das Freizeichen als eigenes Wort
					words[#words+1]={{char, props}}
				
				--ist das Zeichen ein </n> Befehl?
				elseif char == special_chars["nl"] then
					--besitzt das aktuelle Wort Zeichen? Wenn ja, speicher sie und setze das Wort zurück
					if #word > 0 then
						words[#words+1] = word
					
						word={}
					end
					
					--speicher den </n> Befehl als eigenes Wort
					words[#words+1]={{"</n>", props}}
					
				elseif char ~= special_chars["pre"] then
					--füge dem aktuellen Wort das Zeichen hinzu
					word[#word+1]={char, props}
					
					
					if i == #spans and j == char_string_len then
						words[#words+1] = word
					end
				end
			end
		end
		
		create_text()
	end

	
	create_text = function()
		local words = textbox.words
		local lines = textbox.lines
		
		local spacing = textbox.spacing
		local box_width, box_height = textbox.box_width, textbox.box_height
		local text_align = textbox.text_align
		local line_height = textbox.line_height
		local font_size = textbox.font_size
		local font_color = textbox.font_color
		local spacing = textbox.spacing
		local uppercase = textbox.uppercase
		
		--erzeuge eine neue Zeile
		local actual_line = create_line()		
		
		--gehe jedes Wort einzeln durch
		for i=1, #words do
			local word = words[i]
			
			--ist der Inhalt des Wortes der Befehl </n>?
			if word[1][1] == "</n>" then
				--ist die Zeile leer? dann gib ihr als max Größe die Schriftgröße
				if actual_line.max_size == 0 then 
					if word[1][2]["size"] then
						actual_line.max_size = word[1][2]["size"] 
					else
						actual_line.max_size = font_size 
					end
				end
				
				actual_line = create_line()
				
			else
				word.max_size = 0
				
				--gehe jeden Buchstaben des Wortes einzeln durch
				for j=1, #word do
					local char = word[j]
					local char_string = char[1]
					local char_props = char[2] or {}
					local color = char_props["color"] or font_color
					local size = char_props["size"] or font_size
					local style = char_props["style"]
					
					if special_chars[char_string] then 
						char_string = special_chars[char_string]
						char[1] = char_string
					end 
					--wenn uppercase aktiv dann alle buchstaben groß schreiben
					if uppercase == true then 
						char_string = setUpperCase(char_string)
						word[j][1] = char_string
					 end
					 
					--erzeuge neues Textfeld mit dem Buchstaben als Inhalt
					
					local letter = display.newText(char_string, 0, 0, font_name, size)
					letter.anchorX, letter.anchorY = 0.5, 0.5
					char[3] = letter
					actual_line:insert(letter)
					
					letter:setFillColor(color[1],color[2],color[3])
					
					--ist die Größe des Buchstaben größer als die maximal Größe des Wortes?
					if size > word.max_size then word.max_size = size end
					
					local letter_ratio = letter_ratios[char_string] or 1
					local width_before = size*letter_ratio
					local width_after = size*letter_ratio
					local kerning = 1
					
					if j>1 then
						local last_letter = word[j-1][1]
						if kerning_pairs[last_letter] then
							kerning = kerning_pairs[last_letter][char_string] or 1
						end
					end
					
					--hat dieser Buchstabe eine definierte Breite?
					if char_width[char_string] then 
						width_before = width_before*char_width[char_string][1]
						width_after = width_after*char_width[char_string][2] 
					end
					
					--addiere vordere und hintere Breite des buchstanben zur Zeilenlänge
					actual_line.lineLength = actual_line.lineLength + width_before*0.5*kerning
					letter.x, letter.y = actual_line.lineLength, 0
					actual_line.lineLength = actual_line.lineLength+width_after*0.5+spacing*size
					
					--prüfen, ob der Buchstabe unterstrichen sein soll
					if style == "underline" then
						local width = ceil(width_before*0.51*kerning + width_after*0.51+spacing*size)
						local height = size*underline_size
						local line = display.newRect(0,0, width, height)
						line.anchorX, line.anchorY = 0, 0
						line.x, line.y = 0, 0
						line:setFillColor(color[1],color[2],color[3])
						actual_line:insert(line)
						line.x, line.y = letter.x, letter.y+size*underline_height
						letter.underline = line
					end
				end
				
				local letter_ratio = letter_ratios[word[#word][1]] or 1
				local width_after = font_size*letter_ratio*0.5+spacing*font_size
				
				--ist die aktuelle Zeile länger als die Breite der Box? Dann verschiebe das Wort in eine neue Zeile
				if actual_line.lineLength-width_after > box_width then
					if word[1][1]~=" " then
						local old_line_length = actual_line.lineLength
						local old_line = actual_line
					
						actual_line = create_line()
					
						actual_line.max_size = word.max_size
						--gehe jeden Buchstaben durch, verschiebe ihn und ziehe seine Breite von der Zeilelänge ab
						for j=1, #word do
							local char = word[j]
							local char_string = char[1]
							local char_props = char[2] or {}
							local size = char_props["size"] or font_size
					
							local letter = char[3]
							actual_line:insert(letter)
					
							local letter_ratio = letter_ratios[char_string] or 1
							local width_before = size*letter_ratio
							local width_after = size*letter_ratio
	
							if char_width[char_string] then 
								width_before = width_before*char_width[char_string][1]
								width_after = width_after*char_width[char_string][2] 
							end
							
							actual_line.lineLength = actual_line.lineLength + width_before/2
							letter.x, letter.y = actual_line.lineLength, 0
							actual_line.lineLength = actual_line.lineLength+width_after/2+spacing*size
						
							if letter.underline then
								actual_line:insert(letter.underline)
								letter.underline.x, letter.underline.y = letter.x, letter.y+size*underline_height
							end
						
							old_line_length = old_line_length - width_before/2 - (width_after/2+spacing*size)
							
							
						end
					
						--setze die breite der vorherigen Zeile zurück
						old_line.lineLength = old_line_length
						
						--war das Wort davor ein Freizeichen? dann Löschen.
						local last_word = words[i-1] or {}
						local last_word_letter = last_word[1] or {}
						if i > 1 and last_word_letter[1] ==" " then
							local word = last_word
							
							local char = word[1]
							local char_string = char[1]
							local char_props = char[2] or {}
							local size = char_props["size"] or font_size
					
							local letter = char[3]
						
							local letter_ratio = letter_ratios[char_string] or 1
							local width_before = size*letter_ratio
							local width_after = size*letter_ratio
	
							if char_width[char_string] then 
								width_before = width_before*char_width[char_string][1]
								width_after = width_after*char_width[char_string][2] 
							end
						
							--war das Wort unterstrichen? Dann die Linie löschen
							if letter.underline then
								letter.underline:removeSelf()
								letter.underline=nil
							end
						
							letter:removeSelf()
							letter=nil
						
							word[1]=nil
							
							local old_line_length = old_line.lineLength
						
							old_line_length = old_line_length - width_before/2 - (width_after/2+spacing*size)
						
							old_line.lineLength = old_line_length
						end
						
					--war das letzte Wort ein Freizeichen? Dann löschen
					else
						local old_line_length = actual_line.lineLength
						local old_line = actual_line
					
						actual_line = create_line()
						
						local char = word[1]
						local char_string = char[1]
						local char_props = char[2] or {}
						local size = char_props["size"] or font_size
					
						local letter = char[3]
						
						local letter_ratio = letter_ratios[char_string] or 1
						local width_before = size*letter_ratio
						local width_after = size*letter_ratio
	
						if char_width[char_string] then 
							width_before = width_before*char_width[char_string][1]
							width_after = width_after*char_width[char_string][2] 
						end
						
						--war das Wort unterstrichen? Dann die Linie löschen
						if letter.underline then
							letter.underline:removeSelf()
							letter.underline=nil
						end
						
						letter:removeSelf()
						letter=nil
						
						word[1]=nil
						
						old_line_length = old_line_length - width_before/2 - (width_after/2+spacing*size)
						
						old_line.lineLength = old_line_length
					end
				else
					--wenn die Größe des aktuellen Wortes größer ist als die der Zeile dann wird diese ersetzt
					if word.max_size == 0 then word.max_size = font_size end
					if word.max_size > actual_line.max_size then
						actual_line.max_size = word.max_size
					end
				end
			end
		end
		
		--gehe alle zeilen durch und positioniere sie gemäß ihrer Größe und der Textausrichtung
		for i=1, #lines do
			local line = lines[i]
			local align_offset = 0
			
			if text_align == "right" then
				align_offset = box_width - line.lineLength
			elseif text_align == "center" then
				align_offset = (box_width - line.lineLength)*0.5
			end
			
			local last_line = lines[line.num-1]
			if last_line then
				line.y = last_line.y+(last_line.max_size+line.max_size)*line_height*0.5
			else
				line.y = line.max_size*line_height*0.5
			end
			
			line.x = align_offset
			
			if line.y + line.max_size*line_height > box_height then
				line.isVisible = false
			end
		end
	end
	
	separate_spans(textbox.text)
	
	
	function textbox:reload()
		for i=self.numChildren, 2, -1 do
			local line = self[i]
			
			line:removeSelf()
			line = nil
		end
		
		self.lines = nil
		self.spans = nil
		self.words = nil
		
		self.lines = {}
		self.spans = {}
		self.words = {}
		
		separate_spans(self.text)
	end
	
	
	function textbox:delete()
		for i=self.numChildren, 2, -1 do
			local line = self[i]
			
			line:removeSelf()
			line = nil
		end
		
		self.lines = nil
		self.spans = nil
		self.words = nil
		
		self:removeSelf()
		textbox = nil
	end
	
	
	function textbox:changeProperty(arg)
		font_set_name = arg.set_name or font_set_name
		font_set = fontbox.fonts[font_set_name]
		font_name = font_set.font_name or nativeSystemFont
		char_width = font_set.char_width
		all_letters = font_set.all_letters
		kerning_pairs = font_set.kerning_pairs
		letter_ratios = font_set.letter_ratios
		underline_size = font_set.underline_size
		underline_height = font_set.underline_height
		
		textbox.x, textbox.y = arg.x or textbox.x, arg.y or textbox.y
		textbox.box_width, textbox.box_height = arg.width or textbox.box_width, arg.height or textbox.box_height
		textbox.text_align = arg.align or textbox.text_align
		textbox.line_height = arg.line_height or textbox.line_height
		textbox.font_size = arg.size or textbox.font_size
		textbox.font_color = arg.color or textbox.font_color
		textbox.spacing = arg.spacing or textbox.spacing
		textbox.text = arg.text or textbox.text
		if arg.uppercase == true or arg.uppercase == false then
			textbox.uppercase = arg.uppercase
		end
		
		textbox:reload()
	end
	
	
	function textbox:showBackground()
		bgbox.isVisible = true
	end
	
	function textbox:hideBackground()
		bgbox.isVisible = false
	end
	
	
	return textbox
end


function fontbox.addSpecialCharacters(t)
	local t = t
	
	for i=1, #t do
		local char = t[i]
		local sub_char = ssub(char,2,2)
		
		special_chars[sub_char] = char
	end
end


function fontbox.addSpecialUppercase(t)
	local t = t
	
	for i=1, #t do
		local char = t[i][1]
		local upper = t[i][2]
		
		special_uppercase[char] = upper
	end
end




return fontbox