B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=9.01
@EndOfDesignText@
Sub Process_Globals
	Private xui As XUI
End Sub



Sub Tamanho_TextoVertical(lb As Label,texto As String) As Int
	If texto.Length < 1 Then Return 0
	Private su As StringUtils
	Return su.MeasureMultilineTextHeight(lb,texto)
End Sub



Sub Set_StatusBarColor(clr As Int)
	Dim p As Phone
	If p.SdkVersion >= 21 Then
		Dim jo As JavaObject
		jo.InitializeContext
		Dim window As JavaObject = jo.RunMethodJO("getWindow", Null)
		window.RunMethod("addFlags", Array (0x80000000))
		window.RunMethod("clearFlags", Array (0x04000000))
		window.RunMethod("setStatusBarColor", Array(clr))
	End If
End Sub


Sub Imagem_Redonda (iv As ImageView, pasta As String, imagem As String )
	Private Input As B4XBitmap = LoadBitmapResize(pasta,imagem,iv.Width,iv.Height,True)
	If Input.Width <> Input.Height Then
		Dim l As Int = Min(Input.Width, Input.Height)
		Input = Input.Crop(Input.Width / 2 - l / 2, Input.Height / 2 - l / 2, l, l)
	End If
	Dim c As B4XCanvas
	Dim xview As B4XView = xui.CreatePanel("")
	xview.SetLayoutAnimated(0, 0, 0, iv.Width, iv.Width)
	c.Initialize(xview)
	Dim path As B4XPath
	path.InitializeOval(c.TargetRect)
	c.ClipPath(path)
	c.DrawBitmap(Input.Resize(iv.Width, iv.Width, False), c.TargetRect)
	c.RemoveClip
	c.Invalidate
	Dim res As B4XBitmap = c.CreateBitmap
	c.Release
	iv.Bitmap = res
End Sub




Sub Tamanho_TextoHorizontal(lb As Label, Texto As String) As Int
	Private bmp As Bitmap
	bmp.InitializeMutable(1dip, 1dip)
	Private cvs As Canvas
	cvs.Initialize2(bmp)
	Return cvs.MeasureStringWidth(Texto, lb.Typeface , lb.TextSize)
End Sub



Sub setPadding(v As View, Left As Int, Top As Int, Right As Int, Bottom As Int)
	Dim jo = v As JavaObject
	jo.RunMethod("setPadding", Array As Object(Left, Top, Right, Bottom))
End Sub

'
'
'Sub clipBoard_copy(text As String)	
'	Try
'	Dim cp As BClipboard
'	cp.setText(text)
'	ToastMessageShow("Copied",False)
'	Catch
'		Log(LastException)
'	End Try
'
'End Sub