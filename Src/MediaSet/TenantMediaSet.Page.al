page 94782 "Tenant Media Set"
{
    AdditionalSearchTerms = 'System';
    ApplicationArea = All;
    Caption = 'Tenant Media Set';
    PageType = List;
    SourceTable = "Tenant Media Set";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                    ApplicationArea = All;
                }
                field(WhereUsed; WhereUsedInfo)
                {
                    Caption = 'Where Used';
                    ToolTip = 'Specifies the table where this record is used.';
                    ApplicationArea = All;
                    Visible = IsWhereUsedVisible;

                    trigger OnAssistEdit()
                    var
                        WhereMediaSetUsedMeth: Codeunit "WhereMediaSetUsedDtls Meth";
                    begin
                        Message(WhereMediaSetUsedMeth.GetWhereUsedDetails(Rec));
                    end;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.';
                    ApplicationArea = All;
                }
                field("Media ID"; Rec."Media ID")
                {
                    ToolTip = 'Specifies the value of the Media ID field.';
                    ApplicationArea = All;
                }
                field("Media Index"; Rec."Media Index")
                {
                    ToolTip = 'Specifies the value of the Media Index field.';
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ToggleWhereUsed)
            {
                Caption = 'Toggle Where Used';
                Image = ToggleBreakpoint;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Toggle Where Used action.';

                trigger OnAction()
                begin
                    IsWhereUsedVisible := not IsWhereUsedVisible;
                end;
            }
        }
    }

    var
        [InDataSet]
        WhereUsedInfo: Text;
        [IndataSet]
        IsWhereUsedVisible: Boolean;

    trigger OnInit()
    begin
        IsWhereUsedVisible := false;
    end;

    trigger OnAfterGetRecord()
    var
        WherMediaSetUsdInfoMeth: Codeunit WherMediaSetUsdInfoMeth;
    begin
        if not IsWhereUsedVisible then exit;

        WhereUsedInfo := WherMediaSetUsdInfoMeth.GetWhereUsedInfo(Rec);
    end;

}
