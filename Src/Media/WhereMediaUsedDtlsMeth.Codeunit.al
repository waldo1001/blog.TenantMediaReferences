codeunit 94782 "WhereMediaUsedDtls Meth"
{
    /// <summary>
    /// Pretty much the same as "Where Used Info", but now also shows the companies
    /// </summary>    
    internal procedure GetWhereUsedDetails(var TenantMedia: Record "Tenant Media") Result: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetWhereUsedDetails(TenantMedia, Result, IsHandled);

        DoGetWhereUsedDetails(TenantMedia, Result, IsHandled);

        OnAfterGetWhereUsedDetails(TenantMedia, Result);
    end;

    local procedure DoGetWhereUsedDetails(var TenantMedia: Record "Tenant Media"; var Result: Text; IsHandled: Boolean);
    var
        Company: Record Company;
        Fld: Record Field;
    begin
        if IsHandled then
            exit;

        fld.SetRange(ObsoleteState, fld.ObsoleteState::No);
        fld.SetRange(Type, fld.Type::Media);
        if not fld.FindSet() then exit;

        repeat

            if not Company.FindSet() then exit;
            repeat
                if ContainsReference(TenantMedia.ID, fld.TableNo, fld."No.", Company.Name) then
                    if Result = '' then
                        Result := fld.TableName + '(' + format(fld.TableNo) + ') - (' + Company.Name + ')'
                    else
                        Result += '\' + fld.TableName + '(' + format(fld.TableNo) + ') - (' + Company.Name + ')';

            until Company.Next() < 1;

        until fld.Next() < 1;
    end;

    local procedure ContainsReference(TenantMediaId: Guid; TableNo: Integer; FieldNo: Integer; CompanyName: Text[30]): Boolean
    var
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        if TableNo = database::"Table Field Types" then exit(false);        //Scope: OnPrem
        if TableNo = database::"Media Set" then exit(false);                //Scope: OnPrem
        if TableNo = database::"Published Application" then exit(false);    //Scope: OnPrem

        RecRef.Open(TableNo);
        RecRef.ChangeCompany(CompanyName);
        FldRef := RecRef.Field(FieldNo);
        FldRef.SetRange(TenantMediaId);

        exit(not RecRef.IsEmpty);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWhereUsedDetails(var TenantMedia: Record "Tenant Media"; var Result: Text; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhereUsedDetails(var TenantMedia: Record "Tenant Media"; var Result: Text);
    begin
    end;
}