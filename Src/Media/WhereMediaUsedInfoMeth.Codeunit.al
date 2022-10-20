codeunit 94781 "WhereMediaUsedInfoMeth"
{
    /// <summary>
    /// Gets the refence info for this Tenant Media record (Format: "TableName (TableNumber)")
    /// </summary>  
    internal procedure GetWhereUsedInfo(var TenantMedia: Record "Tenant Media") Result: Text
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetWhereUsedInfo(TenantMedia, Result, IsHandled);

        DoGetWhereUsedInfo(TenantMedia, Result, IsHandled);

        OnAfterGetWhereUsedInfo(TenantMedia, Result);
    end;

    local procedure DoGetWhereUsedInfo(var TenantMedia: Record "Tenant Media"; var Result: Text; IsHandled: Boolean);
    var
        Fld: Record Field;
    begin
        if IsHandled then
            exit;

        fld.SetRange(ObsoleteState, fld.ObsoleteState::No);
        fld.SetRange(Type, fld.Type::Media);
        if not fld.FindSet() then exit;

        repeat
            if ContainsReference(TenantMedia.ID, fld.TableNo, fld."No.", TenantMedia."Company Name") then begin
                Result := fld.TableName + '(' + format(fld.TableNo) + ')';
                exit;
            end
        until fld.Next() < 1;
    end;

    local procedure ContainsReference(TenantMediaId: Guid; TableNo: Integer; FieldNo: Integer; CompanyName: Text[30]): Boolean
    var
        FldRef: FieldRef;
        RecRef: RecordRef;
    begin
        if TableNo = database::"Table Field Types" then exit(false); //Scope: OnPrem
        if TableNo = database::"Media Set" then exit(false);         //Scope: OnPrem

        RecRef.Open(TableNo);
        RecRef.ChangeCompany(CompanyName);
        FldRef := RecRef.Field(FieldNo);
        FldRef.SetRange(TenantMediaId);

        exit(not RecRef.IsEmpty);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetWhereUsedInfo(var TenantMedia: Record "Tenant Media"; var Result: Text; var IsHandled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetWhereUsedInfo(var TenantMedia: Record "Tenant Media"; var Result: Text);
    begin
    end;
}