#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "Cadastro de Realce/Localizacao"
Static cCamposChv := "ZP7_DOCBA;"
Static cTabPai    := "ZP7"

/*/zPCPMD2
Cadastro customizado de ralce/localização
@author Eloi
@since 15/10/2022
/*/

User Function zPCPMD2()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)

Return Nil


Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zPCPMD2" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zPCPMD2" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zPCPMD2" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zPCPMD2" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oStruPai   := FWFormStruct(1, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(1, cTabPai)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("zPCPMD2M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZP7MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZP7DETAIL","ZP7MASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("ZP7MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZP7DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZP7_FILIAL", "FWxFilial('ZP7')"} )
	aAdd(aRelation, {"ZP7_DOCBA", "ZP7_DOCBA"})
	oModel:SetRelation("ZP7DETAIL", aRelation, ZP7->(IndexKey(1)))

Return oModel


Static Function ViewDef()
	Local oModel     := FWLoadModel("zPCPMD2")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZP7", oStruPai, "ZP7MASTER")
	oView:AddGrid("GRID_ZP7",  oStruFilho,  "ZP7DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_ZP7", "CABEC")
	oView:SetOwnerView("GRID_ZP7", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZP7", "Cabecalho - ZP7")
	oView:EnableTitleView("GRID_ZP7", "Grid - ZP7")

	//Adicionando campo incremental na grid
	oView:AddIncrementField("GRID_ZP7", "ZP7_REALCE")

Return oView
