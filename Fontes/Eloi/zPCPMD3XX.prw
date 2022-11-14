//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"


Static cTitulo := "Cadastro de Prod. Lavra"
Static cTabPai := "ZPA"
Static cTabFilho := "ZPB"
Static cTabFilho2 := "ZPC"
Static cTabFilho3 := "ZPD"

/*/
Cadastro customizado de Planejamento da ProduÃ§Ã£o do Beneficiamento
@author Eloi
@author Lucas
@author Luis
/*/

User Function zPCPMD3()
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zPCPMD3" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zPCPMD3" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zPCPMD3" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zPCPMD3" OPERATION 5 ACCESS 0

Return aRotina

Static Function ModelDef()
	Local oStruPai := FWFormStruct(1, cTabPai)
	Local oStruFilho := FWFormStruct(1, cTabFilho)
    Local oStruFilho2 := FWFormStruct(1, cTabFilho2)
    Local oStruFilho3 := FWFormStruct(1, cTabFilho3)
	Local aRelation := {}
	Local aRelation2 := {}
    Local aRelation3 := {}
	Local aRelation4 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("zPCPMD3M", bPre, bPos, bCommit, bCancel)
	oModel:AddFields("ZPAMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZPBDETAIL","ZPAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZPCDETAIL","ZPAMASTER",oStruFilho2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
    oModel:AddGrid("ZPDDETAIL","ZPAMASTER",oStruFilho3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
    oModel:SetDescription("Modelo de dados - " + cTitulo)
    
	oModel:GetModel("ZPAMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPBDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:GetModel("ZPCDETAIL"):SetDescription( "Grid de - " + cTitulo)
    oModel:GetModel("ZPDDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})// observar esse caba aqui

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZPA_FILIAL", "FWxFilial('ZPA')"} )
	//aAdd(aRelation, {"ZPB_DOCFL", "ZPA_DOCFL"})
	oModel:SetRelation("ZPADETAIL", aRelation, ZPA->(IndexKey(1)))

	aAdd(aRelation2, {"ZPB_FILIAL", "FWxFilial('ZPB')"} )
	//aAdd(aRelation2, {"ZP9_DOCBMB", "ZPE_DOCFB"})
	oModel:SetRelation("ZPBDETAIL", aRelation2, ZPB->(IndexKey(1)))

	aAdd(aRelation3, {"ZPC_FILIAL", "FWxFilial('ZPC')"} )
	//aAdd(aRelation3, {"ZP9_DOCBMB", "ZPE_DOCFB"})
	oModel:SetRelation("ZPCDETAIL", aRelation3, ZPC->(IndexKey(1)))

	aAdd(aRelation4, {"ZPD_FILIAL", "FWxFilial('ZPD')"} )
	//aAdd(aRelation2, {"ZP9_DOCBMB", "ZPE_DOCFB"})
	oModel:SetRelation("ZPDDETAIL", aRelation4, ZPD->(IndexKey(1)))

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("zPCPMD3")
	//Local cCampoZPA := ''
	//Local cCampoZPB := ''
	//Local cCampoZPC:= ''
	//Local cCampoZPD:= ''
	Local oStruPai := FWFormStruct(2, cTabPai /*, {|cCampo| .NOT. AllTrim(cCampo) $ cCampoZPA}*/) // filtro de campos que não queremos que apareça
	Local oStruFilho := FWFormStruct(2, cTabFilho/*, {|cCampo1|  .NOT. AllTrim(cCampo1) $ cCampoZPB}*/)
	Local oStruFilho2 := FWFormStruct(2, cTabFilho2/*, {|cCampo2| .NOT. AllTrim(cCampo2) $ cCampoZPC}*/)
    Local oStruFilho3 := FWFormStruct(2, cTabFilho3/*, {|cCampo| .NOT. AllTrim(cCampo3) $ cCampoZPD}*/)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZPA", oStruPai, "ZPAMASTER")
	oView:AddGrid("VIEW_ZPB",  oStruFilho,  "ZPBDETAIL")
	oView:AddGrid("VIEW_ZPC",  oStruFilho2,  "ZPCDETAIL")
	oView:AddGrid("VIEW_ZPD",  oStruFilho3,  "ZPDDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)

	oView:CreateFolder('PASTA_FILHOS', 'GRID')

	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO001', 'Budget Mensal Lavra (Lista Que Será Planejado)')
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO002', 'Planejamento Massa Producao')
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO003', 'Plane. Ativ/Serv')


	oView:CreateHorizontalBox('ITENS_FILHO01', 100,,, 'PASTA_FILHOS', 'ABA_FILHO001')
	oView:CreateHorizontalBox('ITENS_FILHO02', 100,,, 'PASTA_FILHOS', 'ABA_FILHO002')
	oView:CreateHorizontalBox('ITENS_FILHO03', 100,,, 'PASTA_FILHOS', 'ABA_FILHO003')

	oView:SetOwnerView("VIEW_ZPA", "CABEC")
	oView:SetOwnerView("VIEW_ZPB", "ITENS_FILHO01")
    oView:SetOwnerView("VIEW_ZPC", "ITENS_FILHO02")
	oView:SetOwnerView("VIEW_ZPD", "ITENS_FILHO03")

	//Adicionando campo incremental na grid
	//oView:AddIncrementField("VIEW_ZPA", "ZPA_FILBML")

Return oView
