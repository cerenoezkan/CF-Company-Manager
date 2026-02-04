<cfif structKeyExists(form, "is_submitted") AND form.is_submitted eq "kullanici_ekle">
    <cfquery datasource="SitemDB">
        INSERT INTO dbo.Kullanicilar (Firstname, Lastname, Email, Role, CreatedDate)
        VALUES (
            <cfqueryparam value="#form.Firstname#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Lastname#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Email#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Role#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
        )
    </cfquery>
    <cflocation url="?mod=kullanicilar" addtoken="false">
</cfif>

<cfif structKeyExists(form, "is_submitted") AND form.is_submitted eq "kullanici_guncelle">
    <cfquery datasource="SitemDB">
        UPDATE dbo.Kullanicilar SET
            Firstname = <cfqueryparam value="#form.Firstname#" cfsqltype="cf_sql_varchar">,
            Lastname = <cfqueryparam value="#form.Lastname#" cfsqltype="cf_sql_varchar">,
            Email = <cfqueryparam value="#form.Email#" cfsqltype="cf_sql_varchar">,
            Role = <cfqueryparam value="#form.Role#" cfsqltype="cf_sql_varchar">
        WHERE ID = <cfqueryparam value="#form.ID#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cflocation url="?mod=kullanicilar" addtoken="false">
</cfif>

<cfif url.mod eq "sil_kullanici" AND structKeyExists(url, "id")>
    <cfquery datasource="SitemDB">
        DELETE FROM dbo.Kullanicilar WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cflocation url="?mod=kullanicilar" addtoken="false">
</cfif>

<cfif url.mod eq "duzenle_kullanici" AND structKeyExists(url, "id")>
    <cfquery name="qKullanici" datasource="SitemDB">
        SELECT * FROM dbo.Kullanicilar WHERE ID = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

<div class="container-fluid">

    <cfif url.mod eq "kullanicilar">
        <cfquery name="qKullanicilar" datasource="SitemDB">
            SELECT * FROM dbo.Kullanicilar ORDER BY Firstname ASC
        </cfquery>
        
        <div class="card">
            <div class="card-header header-flex">
                <h3><i class="fas fa-list"></i> Kullanıcı Listesi</h3>
                <a href="?mod=yeni_kullanici" class="btn-primary"><i class="fas fa-plus"></i> Yeni Kullanıcı</a>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ad</th>
                            <th>Soyad</th>
                            <th>E-posta</th>
                            <th>Rol</th>
                            <th>Tarih</th>
                            <th>İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qKullanicilar">
                        <tr>
                            <td><span class="id-tag">#ID#</span></td>
                            <td>#Firstname#</td>
                            <td>#Lastname#</td>
                            <td>#Email#</td>
                            <td>#Role#</td>
                            <td>#DateFormat(CreatedDate, "dd.mm.yyyy")#</td>
                            <td class="action-buttons">
                                <a href="?mod=duzenle_kullanici&id=#ID#" class="icon-btn edit"><i class="fas fa-pen"></i></a>
                                <a href="?mod=sil_kullanici&id=#ID#" class="icon-btn delete" onclick="return confirm('Emin misin?')"><i class="fas fa-trash"></i></a>
                            </td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

    <cfif url.mod eq "yeni_kullanici">
        <div class="card small-card">
            <div class="card-header"><h3><i class="fas fa-user-plus"></i> Yeni Kullanıcı</h3></div>
            <form method="post" class="grid-form">
                <input type="hidden" name="is_submitted" value="kullanici_ekle">
                <div class="form-group"><label>Ad</label><input type="text" name="Firstname" required></div>
                <div class="form-group"><label>Soyad</label><input type="text" name="Lastname" required></div>
                <div class="form-group"><label>E-posta</label><input type="email" name="Email" required></div>
                <div class="form-group">
                    <label>Rol</label>
                    <select name="Role">
                        <option value="User">User</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-success">Kaydet</button>
                    <a href="?mod=kullanicilar" class="btn-cancel">İptal</a>
                </div>
            </form>
        </div>
    </cfif>

    <cfif url.mod eq "duzenle_kullanici">
        <div class="card small-card">
            <div class="card-header"><h3><i class="fas fa-edit"></i> Düzenle</h3></div>
            <cfoutput query="qKullanici">
            <form method="post" class="grid-form">
                <input type="hidden" name="is_submitted" value="kullanici_guncelle">
                <input type="hidden" name="ID" value="#ID#">
                <div class="form-group"><label>Ad</label><input type="text" name="Firstname" value="#Firstname#" required></div>
                <div class="form-group"><label>Soyad</label><input type="text" name="Lastname" value="#Lastname#" required></div>
                <div class="form-group"><label>E-posta</label><input type="email" name="Email" value="#Email#" required></div>
                <div class="form-group">
                    <label>Rol</label>
                    <select name="Role">
                        <option value="User" <cfif Role eq "User">selected</cfif>>User</option>
                        <option value="Admin" <cfif Role eq "Admin">selected</cfif>>Admin</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-success">Güncelle</button>
                    <a href="?mod=kullanicilar" class="btn-cancel">İptal</a>
                </div>
            </form>
            </cfoutput>
        </div>
    </cfif>
</div>