codeunit 94783 "WhereMediaSetUsedDtls Meth"
{
    /// <summary>
    /// Pretty much the same as "Where Used Info", but now also shows the companies
    /// </summary>  
    internal procedure GetWhereUsedDetails(var TenantMediaSet: Record "Tenant Media Set") Result: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetWhereUsedDetails(TenantMediaSet, Result, IsHandled);

        DoGetWhereUsedDetails(TenantMediaSet, Result, IsHandled);

        OnAfterGetWhereUsedDetails(TenantMediaSet, Result);
    end;

    local procedure DoGetWhereUsedDetails(var TenantMediaSet: Record "Tenant Media Set"; var Result: Text; IsHandled: Boolean);
    var
        Company: Record Company;
        Fld: Record Field;
    begin
        if IsHandled then
            exit;

        fld.SetRange(ObsoleteState, fld.ObsoleteState::No);
        fld.SetRange(Type, fld.Type::MediaSet);
        if not fld.FindSet() then exit;

        repeat

            if not Company.FindSet() then exit;
            repeat
                if ContainsReference(TenantMediaSet.ID, fld.TableNo, fld."No.", Company.Name) then
                    if Result = '' then
                        Result := fld.TableName + '(' + format(fld.TableNo) + ') - (' + Company.Name + ')'
                    else
                        Result += '\' + fld.TableName + '(' + format(fld.TableNo) + ') - (' + Company.Name + ')';

            until Company.Next() < 1;

        until fld.Next() < 1;
    end;

    local procedure ContainsReference(TenantMediaSetId: Guid; TableNo: Integer; FieldNo: Integer; CompanyName: Text[30]): Boolean
    var
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        RecRef.Open(TableNo);
        RecRef.ChangeCompany(CompanyName);
        FldRef := RecRef.Field(FieldNo);
        FldRef.SetRange(TenantMediaSetId);

        exit(not RecRef.IsEmpty);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWhereUsedDetails(var TenantMediaSet: Record "Tenant Media Set"; var Result: Text; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhereUsedDetails(var TenantMediaSet: Record "Tenant Media Set"; var Result: Text);
    begin
    end;
}