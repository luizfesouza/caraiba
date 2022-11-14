//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo := "Forecast da Lavra"
Static cTabPai := "ZPA"
Static cTabFilho := "ZPB"
Static cTabFilho2 := "ZPC"
// Static cTabFilho3 := "ZPD"

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
	Local oStruPai := FWFormStruct(1, cTabPai) // ZPA
	Local oStruFilho := FWFormStruct(1, cTabFilho) // ZPB
    Local oStruFilho2 := FWFormStruct(1, cTabFilho2) // ZPC
    // Local oStruFilho3 := FWFormStruct(1, cTabFilho3) // ZPD
	Local aRelation := {}
	Local aRelation2 := {}
    // Local aRelation3 := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCommit := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("RPCPA007M", bPre, bPos, bCommit, bCancel)
	
    oModel:AddFields("ZPAMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZPBDETAIL","ZPAMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:AddGrid("ZPCDETAIL","ZPAMASTER",oStruFilho2,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	// oModel:AddGrid("ZPDDETAIL","ZPAMASTER",oStruFilho3,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)


    oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("ZPAMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZPBDETAIL"):SetDescription( "Grid de - " + cTitulo)
    oModel:GetModel("ZPCDETAIL"):SetDescription( "Grid de - " + cTitulo)
    // oModel:GetModel("ZPDDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	// PAI: ZPA
	// FILHO1: ZPB
	// FILHO2: ZPC
	// FILHO3: ZPD
	
	// Fazendo o relacionamento
	aAdd(aRelation, {"ZPB_FILIAL", "FWxFilial('ZPB')"} )
	aAdd(aRelation, {"ZPA_DOCFL", "ZPB_DOCFL"})
	aAdd(aRelation, {"ZPB_DOCFL", "ZPC_DOCFL"})
	aAdd(aRelation, {"ZPA_VER", "ZPB_VER"})
	oModel:SetRelation("ZPBDETAIL", aRelation, ZPB->(IndexKey(1)))

	aAdd(aRelation2, {"ZPC_FILIAL", "FWxFilial('ZPC')"} )
	// aAdd(aRelation2, {"ZPC_DOCFL", "ZPD_DOCFL"})
	oModel:SetRelation("ZPCDETAIL", aRelation2, ZPC->(IndexKey(1)))
    
    // aAdd(aRelation3, {"ZPD_FILIAL", "FWxFilial('ZPD')"} )
	// aAdd(aRelation3, {"ZPD_DOCFL", "ZPC_DOCFL"})
	// oModel:SetRelation("", aRelation3, ZPD->(IndexKey(1)))

Return oModel

Static Function ViewDef()
	Local oModel := FWLoadModel("RPCPA007")

	// Campos no Browse:
	// (DOCUMENTO) 
	// Doc. Forecast, Vers�o, Ano Base, M�s Base, Produto, Saldo Atual
	// (Budget Mensais Lavra - Lista do que ser� planejado)
	// Doc Budget Mensal, Realce, %Teor, %Rec., Metal, Qtd Massa, Saldo Remanescente
	// (Plan. Massa Produ��o)
	// Realce, Dia 01, Dia 02, Dia 03, ..., Dia 31
	// (Plan. Atividade/Servi�o)
	// Realce, Seq, Atividade, Unid. Med., Prop/Terc, Dia 01, Dia 02, ... Dia 31, Qtd. Min�rio, Qtd. Esteril, CAPEX/OPEX
	// Local cCampoZPA := ''
	// Local cCampoZPB := ''
	// Local cCampoZPC := ''
    // Local cCampoZPD := ''
	
	// Local oStruPai := FWFormStruct(2, cTabPai , {|cCampo| .NOT. AllTrim(cCampo) $ cCampoZPA})
	Local oStruPai := FWFormStruct(2, cTabPai )
	Local oStruFilho := FWFormStruct(2, cTabFilho)
	Local oStruFilho2 := FWFormStruct(2, cTabFilho2)
    // Local oStruFilho3 := FWFormStruct(2, cTabFilho3)
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZPA", oStruPai, "ZPAMASTER")
	oView:AddGrid("VIEW_ZPB",  oStruFilho,  "ZPBDETAIL")
	oView:AddGrid("VIEW_ZPC",  oStruFilho2,  "ZPCDETAIL")
	// oView:AddGrid("VIEW_ZPD",  oStruFilho3,  "ZPDDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)

	oView:CreateFolder('PASTA_FILHOS', 'GRID')

	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO001', 'Budget Mensal Lavra (Lista que ser� planejado)')
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO002', 'Plan. Massa Producao')
    // oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO003', 'Plan. Ativ/Servi�o')

	oView:CreateHorizontalBox('ITENS_FILHO01', 100,,, 'PASTA_FILHOS', 'ABA_FILHO001')
	oView:CreateHorizontalBox('ITENS_FILHO02', 100,,, 'PASTA_FILHOS', 'ABA_FILHO002')
	// oView:CreateHorizontalBox('ITENS_FILHO03', 100,,, 'PASTA_FILHOS', 'ABA_FILHO003')

	oView:SetOwnerView("VIEW_ZPA", "CABEC")
	oView:SetOwnerView("VIEW_ZPB", "ITENS_FILHO01")
    oView:SetOwnerView("VIEW_ZPC", "ITENS_FILHO02")
	// oView:SetOwnerView("VIEW_ZPD", "ITENS_FILHO03")

	//Adicionando campo incremental na grid
	//oView:AddIncrementField("VIEW_ZPF", "ZPF_FILBML")

Return oView