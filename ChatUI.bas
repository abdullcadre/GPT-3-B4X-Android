B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=12
@EndOfDesignText@

#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	Type mensagemTexto (mensagem As String, assistente As Boolean)
	Private su As StringUtils
	Dim temText As String=""
End Sub

Sub Globals
	
	'TECLADO
	Private ime As IME
	Private heightTeclado As Int
	Private tamanhoMaximo As Int = 0
	

	'CHAT
	Private clvMensagens As CustomListView
	Private edEscrever As EditText
	Private icEscrever As ImageView
	Private pEscrever As Panel
	Private pTopMenu As Panel
'	Private lbTituloTopMenu As Label
'	Private icMenuTopMenu As ImageView
'	Private icConfigTopMenu As ImageView
'	
	
	'CLV TEXTO ASSISTENTE
	Private lbTextoAssistente As Label
	Private pFundoFala As Panel
	Private imgPontaAssistente As ImageView
	
	'CLV TEXTO USUÁRIO
	Private lbTextoUsuario As Label
	Private pFundoFalaUsuario As Panel
	Private imgPontaUsuario As ImageView
	
	
	
	
	Private lbTitle As Label
	Private Label2more As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'geral.Set_StatusBarColor(Colors.RGB(89,89,89))
	Activity.LoadLayout("1")
	
	ime.Initialize("ime")
	ime.AddHeightChangedEvent
	
	
	'TOP MENU
	Private csTitulo As CSBuilder
	csTitulo.Initialize
	csTitulo.Color(Colors.Black).Append("Robozinho").Color(0xffB2D8BB).Size(10).Append(CRLF&"● Online").PopAll
	lbTitle.Text = csTitulo

	Private cc As ColorDrawable
	cc.Initialize2(Colors.RGB(250,250,250),10,2,Colors.LightGray)
	pEscrever.Background = cc
	edEscrever.Background = Null
	geral.setPadding(edEscrever,0,0,0,0) 'REMOVE PADDING DO EDITTEXT
	
	icEscrever.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "eVoz.png", icEscrever.Width, icEscrever.Height, True)).Gravity = Gravity.CENTER
	icEscrever.Tag = "voz"


	'CHAMA A FUNÇÃO DE AJUSTAR TAMANHO DO TECLADO
	IME_HeightChanged(100%y,0)
	tamanhoMaximo = su.MeasureMultilineTextHeight(edEscrever,"teste de tamanho!") * 6 '6 LINHAS O EDITTEXT VAI AUMENTAR, DEPOIS DISSO APARECER O SCROLL
'For i=0 To 10
''		clvMensagens.Add(CreateItem("",5,""),"qual tamanho normal do corpo do bebe")
'Next
End Sub

Sub Activity_Resume
	AjustaTamanho_Clv
	Esconde_Teclado
	IME_HeightChanged(100%y,0)
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Sub clvMensagens_ItemClick (Index As Int, Value As Object)	
	Try
		
		Dim m As mensagemTexto
		m.Initialize
		m=Value
		temText=m.mensagem

	Dim ac As ACPopupMenu
	ac.Initialize("ac",clvMensagens.GetRawListItem(Index).Panel)
	ac.AddMenuItem(1,"Copy",Null)
'	ac.AddMenuItem(2,"Reedit",Null)
'	ac.AddMenuItem(3,"ola 3",Null)
	ac.Show	
	Catch
		Log(LastException)
	End Try
End Sub


Private Sub ac_ItemClicked (Item As ACMenuItem)
	If Item.Id=1 Then
'		geral.clipBoard_copy(temText)
	End If
	If Item.Id=2 Then
		
		edEscrever.Text=temText
	End If
End Sub

Sub clvMensagens_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)
	
	Try
		
	
	Dim ExtraSize As Int = 2
	For i = 0 To clvMensagens.Size - 1
		Dim p As Panel = clvMensagens.GetPanel(i)
		If i > FirstIndex - ExtraSize And i < LastIndex + ExtraSize Then
			If p.NumberOfViews = 0 Then
				
				Dim m As mensagemTexto = clvMensagens.GetValue(i)
				
				If m.assistente Then
		
					p.LoadLayout("clvTextoAssistente")
					lbTextoAssistente.Text = m.mensagem
	
					imgPontaAssistente.Height = 3%y
					imgPontaAssistente.Top = 0
					imgPontaAssistente.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "ponta.png", imgPontaAssistente.Width, imgPontaAssistente.Height, False)).Gravity = Gravity.CENTER
					
					'AJUSTA VERTICAL
					Private margemTop As Int = 1%y : Private margemBottom As Int = 1%y
					lbTextoAssistente.Height = geral.Tamanho_TextoVertical(lbTextoAssistente,lbTextoAssistente.Text)
					lbTextoAssistente.Top = 0%y + margemTop
					
					'AJUSTA HORIZONTAL
					If geral.Tamanho_TextoHorizontal(lbTextoAssistente,lbTextoAssistente.Text) < 82%x Then
						lbTextoAssistente.Width = geral.Tamanho_TextoHorizontal(lbTextoAssistente,lbTextoAssistente.Text)
						lbTextoAssistente.SingleLine = True
						pFundoFala.Width = lbTextoAssistente.Width +4%x
					End If
					
					pFundoFala.Height = lbTextoAssistente.Height + margemTop + margemBottom
					clvMensagens.ResizeItem(i,pFundoFala.Height)
				
				Else
					
					p.LoadLayout("clvTextoUsuario")
					lbTextoUsuario.Text = m.mensagem
					
					imgPontaUsuario.Height = 3%y
					imgPontaUsuario.Top = 0
					imgPontaUsuario.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "pontaCinza.png", imgPontaUsuario.Width, imgPontaUsuario.Height, False)).Gravity = Gravity.CENTER
					
					'AJUSTA VERTICAL
					Private margemTop As Int = 1%y : Private margemBottom As Int = 1%y
					lbTextoUsuario.Height = geral.Tamanho_TextoVertical(lbTextoUsuario,m.mensagem)
					lbTextoUsuario.Top = 0%y + margemTop
					
					'AJUSTA HORIZONTAL
					If geral.Tamanho_TextoHorizontal(lbTextoUsuario,lbTextoUsuario.Text) < 82%x Then
						lbTextoUsuario.Width = geral.Tamanho_TextoHorizontal(lbTextoUsuario,lbTextoUsuario.Text)
						lbTextoUsuario.SingleLine = True
						pFundoFalaUsuario.Width = lbTextoUsuario.Width +4%x
						pFundoFalaUsuario.Left = 100%x - pFundoFalaUsuario.Width - 4%x
					End If
	
					pFundoFalaUsuario.Height = lbTextoUsuario.Height + margemTop + margemBottom
					clvMensagens.ResizeItem(i,pFundoFalaUsuario.Height)
			
				End If
				
				
				
				
				
				
			End If
		Else
			If p.NumberOfViews > 0 Then
				p.RemoveAllViews
			End If
		End If
	Next
	
	Catch
		Log(LastException)
	End Try
	
End Sub










Sub edEscrever_TextChanged (Old As String, New As String)
	
	'ICONE VOZ OU TEXTO
	If New.Length > 0 Then
		icEscrever.Enabled=True
		icEscrever.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "eMensagem.png", icEscrever.Width, icEscrever.Height, True)).Gravity = Gravity.CENTER
		icEscrever.Tag = "texto"
	Else
		icEscrever.Enabled=False
		icEscrever.SetBackgroundImage(LoadBitmapResize(File.DirAssets, "eMensagem.png", icEscrever.Width, icEscrever.Height, True)).Gravity = Gravity.CENTER
		icEscrever.Tag = "voz"
	End If
	
	
	
	Private i As Int = su.MeasureMultilineTextHeight(edEscrever,New)
	If i > tamanhoMaximo Then Return 'CHEGOU NO LIMITE DE TAMANHO
	
	If i > 7%y Then 'ESTÁ PEQUENO, VAMOS AUMENTAR ATÉ O LIMITE
		pEscrever.Height = i
		edEscrever.Height = i
		pEscrever.Top = heightTeclado - pEscrever.Height - 1%y
		AjustaTamanho_Clv
	End If
	
End Sub



Sub IME_HeightChanged(NewHeight As Int, OldHeight As Int)
	Try
		heightTeclado = NewHeight
	pEscrever.SetLayout(pEscrever.Left, heightTeclado - pEscrever.Height - 1%y, pEscrever.Width, pEscrever.Height)
	icEscrever.SetLayout(icEscrever.Left, heightTeclado - icEscrever.Height - 1%y, icEscrever.Width, icEscrever.Height)
	AjustaTamanho_Clv	
	Catch
		Log(LastException)
	End Try

End Sub



Sub AjustaTamanho_Clv
	clvMensagens.AsView.Top = 0 + pTopMenu.Height
	clvMensagens.AsView.Height = pEscrever.Top - pTopMenu.Height - 1%y
	clvMensagens.Base_Resize(clvMensagens.AsView.Width,clvMensagens.AsView.Height)
	Sleep(0) 'PARA TER CERTEZA QUE AJUSTOU O TAMANHO, ANTES DE DESCER O SCROLL (IMPORTANTE O SLEEP AQUI!)
	If clvMensagens.Size > 0 Then clvMensagens.JumpToItem(clvMensagens.Size - 1)
End Sub





Sub icEscrever_Click
	If icEscrever.Tag = "texto" Then
		Private sTexto As String = edEscrever.Text.Trim
		Esconde_Teclado
		Escreve_Usuario(sTexto)
		'Conversa_Bot
		generate_gpt3_response(sTexto)
	Else
		'IME_HeightChanged(0,0)
		IME_HeightChanged(100%y,0)
		
	End If
End Sub











Sub Escreve_Usuario(mensagem As String) 'LADO DIREITO (CINZA)
	Dim m As mensagemTexto
	m.Initialize
	m.mensagem = mensagem
	m.assistente = False
	Dim p As Panel
	p.Initialize("p")
	p.SetLayoutAnimated(0, 0, 0, clvMensagens.AsView.Width, 15%y)
	clvMensagens.Add(p, m)
	AjustaTamanho_Clv
End Sub


Sub Escreve_Bot(mensagem As String) 'LADO ESQUERDO (AZUL)
	Dim m As mensagemTexto
	m.Initialize
	m.mensagem = mensagem
	m.assistente = True
	Dim p As Panel
	p.Initialize("p")
	p.SetLayoutAnimated(0, 0, 0, clvMensagens.AsView.Width, 15%y)
	clvMensagens.Add(p, m)
	AjustaTamanho_Clv
End Sub

Sub Esconde_Teclado
	edEscrever.Text = ""
	pEscrever.Height = 7%y
	edEscrever.Height = 7%y
	ime.HideKeyboard
End Sub






'RESPOSTAS DO BOT
Sub Conversa_Bot
	If clvMensagens.Size = 2 Then
		Sleep(1200)
		Escreve_Bot("Poxa que bom cara! O que você quer fazer hoje?")
	else if clvMensagens.Size = 4 Then
		Sleep(1200)
		Escreve_Bot("kkkkkk mas denovo? 🤔")
	else if clvMensagens.Size = 6 Then
		Sleep(1200)
		Escreve_Bot("então bora lá.... 🍺🍺🍺🍻🍻")
	else if clvMensagens.Size = 8 Then
		Sleep(1200)
		Escreve_Bot("wtf???")
	End If
End Sub



Sub Processing
	Private csTitulo As CSBuilder
	csTitulo.Initialize
	csTitulo.Color(Colors.Black).Append("Botizinho").Color(0xff0176c5).Size(10).Append(CRLF&"Generate response...").PopAll
	lbTitle.Text = csTitulo
	edEscrever.Enabled=False
End Sub


Sub sucessResponse
	Private csTitulo As CSBuilder
	csTitulo.Initialize
	csTitulo.Color(Colors.Black).Append("Botizinho").Color(0xffB2D8BB).Size(10).Append(CRLF&"● Online").PopAll
	lbTitle.Text = csTitulo
	edEscrever.Enabled=True
End Sub






Sub generate_gpt3_response(sTexto As String)
	Try
		Processing
		Dim m As Map = CreateMap("n":1,"stop":"None","model": "text-davinci-003", "prompt": sTexto,"max_tokens":350,"temperature":0.5)
		Dim js As JSONGenerator
		js.Initialize(m)

		Log(js.ToString)
		
		Dim req As HttpJob
		req.Initialize("",Me)
		req.PostString("https://api.openai.com/v1/completions",js.ToString)
		req.GetRequest.SetHeader("Authorization","Bearer YOUR API KEY")
		req.GetRequest.SetHeader("OpenAI-Organization","YOUR ORG")
		req.GetRequest.SetContentType("application/json")
		Wait For (req) jobdone(req As HttpJob)
		If req.Success Then
			sucessResponse		
			Log(req.GetString)
			Dim parser As JSONParser
			parser.Initialize(req.GetString)
			Dim jRoot As Map = parser.NextObject
			Dim choices As List = jRoot.Get("choices")
			For Each colchoices As Map In choices
				Dim text As String = colchoices.Get("text")
				Escreve_Bot(text.Trim)
			Next
		Else
			edEscrever.Enabled=True
			Log(req.ErrorMessage)
		End If
		req.Release
	Catch
		Log(LastException)
	End Try
	
End Sub


Sub CreateItem(Title As String, color As Int,icon As String) As B4XView
	Dim xui As XUI
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, clvMensagens.AsView.Width, 58dip)
	p.LoadLayout("questionsugets")
	Return p
End Sub

Private Sub Label2more_Click
	Try
		Dim ac As ACPopupMenu
		ac.Initialize("more",Label2more)
		ac.AddMenuItem(1,"Clear",Null)
		ac.AddMenuItem(2,"About",Null)
		ac.AddMenuItem(3,"Exit app",Null)
		ac.Show
	Catch
		Log(LastException)
	End Try
End Sub

Private Sub more_ItemClicked (Item As ACMenuItem)
	If Item.Id=1 Then
		
		Msgbox2Async("Do you want to clear all chat?", "Clear", "Yes", "", "No", Null, False)
		Wait For Msgbox_Result (Result As Int)
		If Result = DialogResponse.POSITIVE Then
			'...
			clvMensagens.Clear
		End If
		
	End If
	
	If Item.Id=3 Then
		
		Msgbox2Async("Do you want to exit?", "Exit", "Yes", "", "No", Null, False)
		Wait For Msgbox_Result (Result As Int)
		If Result = DialogResponse.POSITIVE Then
			clvMensagens.Clear
			Activity.Finish
			
		End If
		
	End If
	If Item.Id=2 Then
		
		MsgboxAsync("Created by Abdul Cadre", "About app")
		
	End If
	
End Sub