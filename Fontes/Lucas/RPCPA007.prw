//Bibliotecas
//CAMPO VIRTUAL / POSICIONE
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Cadastro de Planejamento da Producao Beneficiamento"
Static cTabPai := "ZPA"
Static cTabFilho := "ZPB"
Static cTabFilho2 := "ZPC"

/*/
Cadastro customizado de Planejamento da Produção do Beneficiamento
@author Eloi
@author Lucas
@author Luis
/*/

User Function RPCPA007()
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.RPCPA007" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.RPCPA007" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.RPCPA007" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.RPCPA007" OPERATION 5 ACCESS 0
Return aRotina

Static Function ModelDef()


	Local oStruPai := FWFormStruct(1, cTabPai)   
	Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oStruZPC := FWFormStruct(1, cTabFilho2)
	Local aRelation := {}
	Local aRelation2 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("RPCPA007M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZPAMASTER", /*cOwner*/, oStruPai)
	
	oModel:AddGrid("ZPBDETAIL","ZPAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZPCDETAIL","ZPBDETAIL",oStruZPC,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	
	oModel:GetModel("ZPAMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPBDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZPCDETAIL"):SetDescription( "Grid de - " + cTitulo)
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

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("RPCPA007")

	// , cTabFilho2, {|cCampo2|   AllTrim(cCampo2) $ "ZPC_FILBML,ZPC_DOCBML,ZPC_REALCE,ZPC_QTD" }      

	Local oStruPai := FWFormStruct(2, cTabPai)   
	Local oStruFilho := FWFormStruct(2, cTabFilho)
    Local oStruZPC := FWFormStruct(2, cTabFilho2)
	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	 
	oView:AddField("VIEW_ZPA", oStruPai, "ZPAMASTER")

	oView:AddGrid("VIEW_ZPB",  oStruFilho,  "ZPBDETAIL")
	oView:AddGrid("VIEW_ZPC",  oStruZPC,  "ZPCDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 28)
	oView:CreateHorizontalBox("GRID", 36)
	oView:CreateHorizontalBox("GRID1", 36)


	oView:SetOwnerView("VIEW_ZPA", "CABEC")

	oView:SetOwnerView("VIEW_ZPB", "GRID")
    oView:SetOwnerView("VIEW_ZPC", "GRID1")

	oView:EnableTitleView("VIEW_ZPA", "Documento ")
	oView:EnableTitleView("VIEW_ZPB", "Budget Mensais Lavra (Lista que sera planejado)")
	oView:EnableTitleView("VIEW_ZPC", "Plan.Massa Producao")


	//Adicionando campo incremental na grid
Return oView


