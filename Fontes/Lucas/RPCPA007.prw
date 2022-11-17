//Bibliotecas
#include 'parmtype.ch'
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOPCONN.CH"

//Variveis Estaticas
Static cTitulo := "Cadastro de Planejamento da Produção Da Lavra"
Static cTabPai := "ZPA"
Static cTabFilho := "ZPB"
Static cTabFilho2 := "ZPC"
Static cTabFilho3 := "ZPD"

/*/
Cadastro customizado de Planejamento da Produção do Beneficiamento da Lavra
@author Eloi
@author Lucas
@author Luis
/*/

// Main
User Function RPCPA007()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	aRotina := MenuDef() //Definicao do menu

	oBrowse := FWMBrowse():New() //Instanciando o browse
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()
	oBrowse:Activate() // Ativa o browse

	FWRestArea(aArea)

Return Nil

Static Function MenuDef()
	Local aRotina := {} // Array de menu vazio

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.RPCPA007" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.RPCPA007" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.RPCPA007" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.RPCPA007" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()

	Local oStruPai := FWFormStruct(1, cTabPai)   
	Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oStruZPC := FWFormStruct(1, cTabFilho2)
	Local oStruZPD := FWFormStruct(1, cTabFilho3)
	Local aRelation := {}
	Local aRelation2 := {}
	Local aRelation3 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil

	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("RPCPA07", bPre, bPos, bCommit, bCancel)// obs.: nomear modelo (cID) até 7 char
	oModel:AddFields("ZPAMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZPBDETAIL","ZPAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZPCDETAIL","ZPBDETAIL",oStruZPC,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZPDDETAIL","ZPCDETAIL",oStruZPD,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)

	oModel:SetDescription("Modelo de dados - " + cTitulo)
	
	oModel:GetModel("ZPAMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPBDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZPCDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZPDDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	// //Fazendo o relacionamento
	// aAdd(aRelation, {"ZPB_FILIAL", "FWxFilial('ZPB')"} )
	// aAdd(aRelation, {"ZPB_DOCFB", "ZPA_DOCFB"})
	// oModel:SetRelation("ZPBDETAIL", aRelation, ZPB->(IndexKey(1)))

	// aAdd(aRelation2, {"ZPC_FILIAL", "FWxFilial('ZPC')"} )
	// aAdd(aRelation2, {"ZPC_DOCBMB", "ZPA_DOCBMB"})
	// aAdd(aRelation2, {"ZPC_FILBML", "ZPB_FILBML"})
	// aAdd(aRelation2, {"ZPC_DOCBML", "ZPB_DOCBML"})
	// oModel:SetRelation("ZPCDETAIL", aRelation2, ZPC->(IndexKey(1)))

	// Relacionamento entre tabelas ZPA->ZPB->ZPC->ZPD
	// relacionamento entre pai e filho (ZPA->ZPB)
 	aAdd(aRelation, {FWxFilial("ZPB"), FWxFilial("ZPA")})
	aAdd(aRelation, {"ZPB_DOCFL", "ZPA_DOCFL"})
	aAdd(aRelation, {"ZPB_VER", "ZPA_VER"})

	// relacionamento entre filho1 e filho2 (ZPB->ZPC)
	aAdd(aRelation2, {FWxFilial("ZPC"), FWxFilial("ZPB")})
	aAdd(aRelation2, {"ZPC_DOCFL", "ZPB_DOCFL"})
	aAdd(aRelation2, {"ZPC_VER", "ZPB_VER"})
	aAdd(aRelation2, {"ZPC_DOCBML", "ZPB_DOCBML"})
	aAdd(aRelation2, {"ZPC_REALCE", "ZPB_REALCE"})

	// relacionamento entre filho2 e filho3 (ZPC->ZPD)
	aAdd(aRelation3, {FWxFilial("ZPD"), FWxFilial("ZPC")})
	aAdd(aRelation3, {"ZPD_DOCFL", "ZPC_DOCFL"})
	aAdd(aRelation3, {"ZPD_VER", "ZPC_VER"})
	aAdd(aRelation3, {"ZPD_DOCBML", "ZPC_DOCBML"})
	aAdd(aRelation3, {"ZPD_REALCE", "ZPC_REALCE"})

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("RPCPA007")

	// , cTabFilho2, {|cCampo2|   AllTrim(cCampo2) $ "ZPC_FILBML,ZPC_DOCBML,ZPC_REALCE,ZPC_QTD" }      
	Local oStruPai := FWFormStruct(2, cTabPai, {|cCampo|   AllTrim(cCampo) $ "ZPA_DOCFL,ZPA_VER,ZPA_ANO,ZPA_MES,ZPA_PROD,ZPA_SLDATU" })		// ZPA
	Local oStruFilho := FWFormStruct(2, cTabFilho, {|cCampo1|   AllTrim(cCampo1) $ "ZPB_DOCBML, ZPB_REALCE, ZPB_TEOR, ZPB_REC, ZPB_METAL, ZPB_QTDVLR ,ZPB_SLDREM" })	// ZPB "ZPB_DOCBML, ZPB_REALCE, ZPB_TEOR, ZPB_REC, ZPB_METAL, ZPB_QTDMAS, ZPB_SLDREM"
    Local oStruZPC := FWFormStruct(2, cTabFilho2, {|cCampo2|   AllTrim(cCampo2) $ "ZPC_REALCE, ZPC_QTLD01, ZPC_QTLD02, ZPC_QTLD03, ZPC_QTLD04, ZPC_QTLD05, ZPC_QTLD06, ZPC_QTLD07, ZPC_QTLD08, ZPC_QTLD09, ZPC_QTLD10, ZPC_QTLD11, ZPC_QTLD12, ZPC_QTLD13, ZPC_QTLD14, ZPC_QTLD15, ZPC_QTLD16, ZPC_QTLD17, ZPC_QTLD18, ZPC_QTLD19, ZPC_QTLD20, ZPC_QTLD21, ZPC_QTLD22, ZPC_QTLD23, ZPC_QTLD24, ZPC_QTLD25, ZPC_QTLD26, ZPC_QTLD27, ZPC_QTLD28, ZPC_QTLD29, ZPC_QTLD30, ZPC_QTLD31"})	// ZPC
	Local oStruZPD := FWFormStruct(2, cTabFilho3, {|cCampo3|   AllTrim(cCampo3) $ "ZPD_REALCE, ZPD_SEQ, ZPD_ATIV, ZPD_UM, ZPD_RECURS, ZPD_QTED01, ZPD_QTED02, ZPD_QTED03, ZPD_QTED04, ZPD_QTED05, ZPD_QTED06, ZPD_QTED07, ZPD_QTED08, ZPD_QTED09, ZPD_QTED10, ZPD_QTED11, ZPD_QTED12, ZPD_QTED13, ZPD_QTED14, ZPD_QTED15, ZPD_QTED16, ZPD_QTED17, ZPD_QTED18, ZPD_QTED19, ZPD_QTED20, ZPD_QTED21, ZPD_QTED22, ZPD_QTED23, ZPD_QTED24, ZPD_QTED25, ZPD_QTED26, ZPD_QTED27, ZPD_QTED28, ZPD_QTED29, ZPD_QTED30, ZPD_QTED31, ZPD_QTDVLR, ZPD_QTDEST, ZPD_CONTEX"})	// ZPD

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField("VIEW_ZPA", oStruPai, "ZPAMASTER")
	oView:AddGrid("VIEW_ZPB",  oStruFilho,  "ZPBDETAIL")
	oView:AddGrid("VIEW_ZPC",  oStruZPC,  "ZPCDETAIL")
	oView:AddGrid("VIEW_ZPD", oStruZPD, "ZPDDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 25)	// Cabecalho (ZPA)
	oView:CreateHorizontalBox("GRID", 25)	// Grid ZPB
	oView:CreateHorizontalBox("GRID1", 25)	// Grid ZPC
	oView:CreateHorizontamBox("GRID2", 25)	// Grid ZPD

	oView:SetOwnerView("VIEW_ZPA", "CABEC")
	oView:SetOwnerView("VIEW_ZPB", "GRID")
    oView:SetOwnerView("VIEW_ZPC", "GRID1")
	oView:SetOwnerView("VIEW_ZPD", "GRID2")

	oView:EnableTitleView("VIEW_ZPA", "Documento ")	// Titulo View Cabecalho (ZPA)
	oView:EnableTitleView("VIEW_ZPB", "Budget Mensais Lavra (Lista que sera planejado)") // Título View GRID (ZPB)
	oView:EnableTitleView("VIEW_ZPC", "Plan.Massa Producao") // Título View GRID1 (ZPC)
	oView:EnableTitleView("VIEW_ZPD", "Plan. Atividade/Serviço") // Título View GRID2 (ZPD)

	//Adicionando campo incremental na grid
	// ?
Return oView
