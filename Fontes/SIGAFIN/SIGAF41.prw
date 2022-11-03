//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Forecast Lavra"
Static cTabPai := "ZPA"
Static cTabFilho := "ZPB"

/*/{Protheus.doc} User Function SIGAF41

@author Luiz Souza
@since 02/11/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function SIGAF41()
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

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao SIGAF41
@author Luiz Souza
@since 02/11/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.SIGAF41" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.SIGAF41" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.SIGAF41" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.SIGAF41" OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao SIGAF41
@author Luiz Souza
@since 02/11/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("SIGAF41M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZPAMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZPBDETAIL","ZPAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("ZPAMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPBDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZPB_FILIAL", "FWxFilial('ZPB')"} )
	aAdd(aRelation, {"ZPB_DOCFL", "ZPA_DOCFL"})
	oModel:SetRelation("ZPBDETAIL", aRelation, ZPB->(IndexKey(1)))

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao SIGAF41
@author Luiz Souza
@since 02/11/2022
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel := FWLoadModel("SIGAF41")
	Local oStruPai := FWFormStruct(2, cTabPai)
	Local oStruFilho := FWFormStruct(2, cTabFilho)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZPA", oStruPai, "ZPAMASTER")
	oView:AddGrid("VIEW_ZPB",  oStruFilho,  "ZPBDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_ZPA", "CABEC")
	oView:SetOwnerView("VIEW_ZPB", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZPA", "Cabecalho - ZPA")
	oView:EnableTitleView("VIEW_ZPB", "Grid - ZPB")

	//Removendo campos

Return oView
