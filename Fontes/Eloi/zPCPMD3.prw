//Bibliotecas
//CAMPO VIRTUAL / POSICIONE
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Cadastro de Planejamento da Producao Beneficiamento"
Static cTabPai := "ZPE"
Static cTabFilho := "ZPF"
Static cTabFilho2 := "ZP9"

/*/
Cadastro customizado de Planejamento da Produção do Beneficiamento
@author Eloi
/*/

User Function ZPCPMD3()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ZPCPMD3" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.ZPCPMD3" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.ZPCPMD3" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.ZPCPMD3" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()


	Local oStruPai := FWFormStruct(1, cTabPaI)   
	Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oStruZP9 := FWFormStruct(1, cTabFilho2)
	Local aRelation := {}
	Local aRelation2 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("ZPCPMD3M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZPEMASTER", /*cOwner*/, oStruPai)
	
	oModel:AddGrid("ZPFDETAIL","ZPEMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZP9DETAIL","ZPFDETAIL",oStruZP9,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	
	oModel:GetModel("ZPEMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPFDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZP9DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	// //Fazendo o relacionamento
	aAdd(aRelation, {"ZPF_FILIAL", "FWxFilial('ZPF')"} )
	aAdd(aRelation, {"ZPF_DOCFB", "ZPE_DOCFB"})
	oModel:SetRelation("ZPFDETAIL", aRelation, ZPF->(IndexKey(1)))

	aAdd(aRelation2, {"ZP9_FILIAL", "FWxFilial('ZP9')"} )
	aAdd(aRelation2, {"ZP9_DOCBMB", "ZPE_DOCBMB"})
	aAdd(aRelation2, {"ZP9_FILBML", "ZPF_FILBML"})
	aAdd(aRelation2, {"ZP9_DOCBML", "ZPF_DOCBML"})
	oModel:SetRelation("ZP9DETAIL", aRelation2, ZP9->(IndexKey(1)))

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("ZPCPMD3")

	// ZP9_QTBD01       

	Local oStruPai := FWFormStruct(2, cTabPai, {|cCampo| .NOT. AllTrim(cCampo) $ "ZPE_DTFEC,ZPE_OP,ZPE_DTEXEC"})   
	Local oStruFilho := FWFormStruct(2, cTabFilho, {|cCampo1|  AllTrim(cCampo1) $ "ZPF_FILBML,ZPF_DOCBML,ZPF_REALCE,ZPF_QTDLVR,ZPF_TEOR,ZPF_REC,ZPF_METAL,ZPF_DOCBML"})
    Local oStruZP9 := FWFormStruct(2, cTabFilho2, {|cCampo2|   AllTrim(cCampo2) $ "ZP9_FILBML,ZP9_DOCBML,ZP9_REALCE,ZP9_QTD" })
	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	 
	oView:AddField("VIEW_ZPE", oStruPai, "ZPEMASTER")

	oView:AddGrid("VIEW_ZPF",  oStruFilho,  "ZPFDETAIL")
	oView:AddGrid("VIEW_ZP9",  oStruZP9,  "ZP9DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 28)
	oView:CreateHorizontalBox("GRID", 36)
	oView:CreateHorizontalBox("GRID1", 36)


	oView:SetOwnerView("VIEW_ZPE", "CABEC")

	oView:SetOwnerView("VIEW_ZPF", "GRID")
    oView:SetOwnerView("VIEW_ZP9", "GRID1")

	oView:EnableTitleView("VIEW_ZPE", "Cabecalho ")
	oView:EnableTitleView("VIEW_ZPF", "Budget Mensal Lavra (Lista Passiva de Planejamento do Beneficiamento)")
	oView:EnableTitleView("VIEW_ZP9", "Planejamento Producao")


	//Adicionando campo incremental na grid
Return oView


//oStZP5:AddField('ZP5_LEGEND, "00", AllTrim( ''    ), AllTrim( '' ), { 'Legenda' }, 'C', '@BMP', NIL,'',.F.,NIL,NIL,NIL,NIL     , NIL     , .T.     ,NIL     ,NIL     )
