<!-- Sayfa içerik tipi ve encoding ayarları -->
<cfcontent type="text/html; charset=utf-8">
<cfset setEncoding("form","utf-8")>
<cfset setEncoding("url","utf-8")>

<!-- URL ve form parametreleri için varsayılan değerler -->
<cfparam name="url.mod" default="">
<cfparam name="form.is_submitted" default="0">

<!-- YENİ ŞİRKET EKLEME -->
<cfif form.is_submitted eq "1">
    <cfquery datasource="SitemDB">
        INSERT INTO dbo.COMPANY (
            Symbol,
            SecurityName,
            GICS_Sector,
            GICS_Sub_Industry,
            Sorumlu_Kullanici,
            Headquarters_Location,
            DateAdded,
            CIK,
            Founded
        ) VALUES (
            <cfqueryparam value="#form.Symbol#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.SecurityName#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.GICS_Sector#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.GICS_Sub_Industry#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Sorumlu_Kullanici#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Headquarters_Location#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
            <cfqueryparam value="#form.CIK#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.Founded#" cfsqltype="cf_sql_varchar">
        )
    </cfquery>

    <!-- İşlem sonrası liste sayfasına yönlendirme -->
    <cflocation url="?mod=sirketler" addtoken="false">
</cfif>

<!-- ŞİRKET GÜNCELLEME -->
<cfif form.is_submitted eq "2">
    <cfquery datasource="SitemDB">
        UPDATE dbo.COMPANY SET
            SecurityName = <cfqueryparam value="#form.SecurityName#" cfsqltype="cf_sql_varchar">,
            GICS_Sector = <cfqueryparam value="#form.GICS_Sector#" cfsqltype="cf_sql_varchar">,
            GICS_Sub_Industry = <cfqueryparam value="#form.GICS_Sub_Industry#" cfsqltype="cf_sql_varchar">,
            Sorumlu_Kullanici = <cfqueryparam value="#form.Sorumlu_Kullanici#" cfsqltype="cf_sql_varchar">,
            Headquarters_Location = <cfqueryparam value="#form.Headquarters_Location#" cfsqltype="cf_sql_varchar">,
            CIK = <cfqueryparam value="#form.CIK#" cfsqltype="cf_sql_varchar">,
            Founded = <cfqueryparam value="#form.Founded#" cfsqltype="cf_sql_varchar">
        WHERE Symbol = <cfqueryparam value="#form.Symbol#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- Güncelleme sonrası listeye dön -->
    <cflocation url="?mod=sirketler" addtoken="false">
</cfif>

<!-- DÜZENLEME İÇİN TEK KAYIT ÇEK -->
<cfif url.mod eq "duzenle_sirket" AND structKeyExists(url,"id")>
    <cfquery name="qSirket" datasource="SitemDB">
        SELECT * FROM dbo.COMPANY
        WHERE Symbol = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_varchar">
    </cfquery>
</cfif>

<!-- ŞİRKET SİLME -->
<cfif url.mod eq "sil_sirket" AND structKeyExists(url,"id")>
    <cfquery datasource="SitemDB">
        DELETE FROM dbo.COMPANY
        WHERE Symbol = <cfqueryparam value="#url.id#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <!-- Silme sonrası listeye dön -->
    <cflocation url="?mod=sirketler" addtoken="false">
</cfif>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="utf-8">
    <title>Sistem Yönetim Paneli</title>

    <!-- Icon kütüphaneleri -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <!-- Ana stil dosyası -->
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="container-fluid">

    <!-- Sayfa başlığı -->
    <h2 class="main-title">
        <i class="fas fa-database"></i> Veri Yönetim Sistemi
    </h2>

    <!-- Üst dashboard menüsü -->
    <div class="filter-dashboard">

        <a href="?mod=sirketler" class="filter-card <cfif url.mod eq 'sirketler'>active</cfif>">
            <i class="fas fa-building fa-2x"></i>
            <strong>Şirketler</strong>
        </a>

        <a href="?mod=kullanicilar" class="filter-card <cfif url.mod eq 'kullanicilar'>active</cfif>">
            <i class="fas fa-users fa-2x"></i>
            <strong>Kullanıcılar</strong>
        </a>

        <a href="?mod=eslesenler" class="filter-card <cfif url.mod eq 'eslesenler'>active</cfif>">
            <i class="fas fa-handshake fa-2x"></i>
            <strong>Eşleşenler</strong>
        </a>

    </div>

    <!-- ŞİRKET LİSTESİ -->
    <cfif url.mod eq "sirketler">
        <cfquery name="qSirketler" datasource="SitemDB">
            SELECT * FROM dbo.COMPANY ORDER BY SecurityName
        </cfquery>

        <div class="card">
            <div class="card-header header-flex">
                <h3><i class="fas fa-list"></i> Tüm Şirket Listesi</h3>
                <a href="?mod=yeni_sirket" class="btn-primary">
                    <i class="fas fa-plus"></i> Yeni Şirket Bilgisi Gir
                </a>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Sembol</th>
                            <th>Şirket</th>
                            <th>Sektör</th>
                            <th>Alt Sektör</th>
                            <th>Sorumlu</th>
                            <th>Merkez</th>
                            <th>Tarih</th>
                            <th>CIK</th>
                            <th>Kuruluş</th>
                            <th>İşlem</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qSirketler">
                        <tr>
                            <td><span class="id-tag">#Symbol#</span></td>
                            <td><strong>#SecurityName#</strong></td>
                            <td>#GICS_Sector#</td>
                            <td>#GICS_Sub_Industry#</td>
                            <td><span class="status success">#Sorumlu_Kullanici#</span></td>
                            <td>#Headquarters_Location#</td>
                            <td>#DateFormat(DateAdded,"dd.mm.yyyy")#</td>
                            <td>#CIK#</td>
                            <td>#Founded#</td>

                            <td class="action-buttons">
                                <a href="?mod=duzenle_sirket&id=#Symbol#" class="icon-btn edit">
                                    <i class="fa-solid fa-pen"></i>
                                </a>
                                <a href="?mod=sil_sirket&id=#Symbol#"
                                   onclick="return confirm('Silmek istediğine emin misin?')"
                                   class="icon-btn delete">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif> <!-- ⭐ cfif kapanışı eklendi -->

    <!-- Kullanıcılar modu -->
    <cfif url.mod eq "kullanicilar" 
          OR url.mod eq "yeni_kullanici" 
          OR url.mod eq "duzenle_kullanici" 
          OR url.mod eq "sil_kullanici">
        <cfinclude template="modules/kullanicilar.cfm">
    </cfif>
    
    <cfif url.mod eq "eslesenler">
        <cfinclude template="modules/eslesenler.cfm">
    </cfif>
    
    <!-- YENİ ŞİRKET FORMU -->
    <cfif url.mod eq "yeni_sirket">
        <div class="card small-card">
            <div class="card-header">
                <h3><i class="fas fa-edit"></i> Yeni Şirket Kaydı</h3>
            </div>
            <div class="card-body">
                <form method="post" class="grid-form">
                    <input type="hidden" name="is_submitted" value="1">
                    <div class="form-group">
                        <label>Sembol (Symbol)</label>
                        <input type="text" name="Symbol" required placeholder="Örn: AAPL">
                    </div>
                    <div class="form-group">
                        <label>Şirket Adı (Security Name)</label>
                        <input type="text" name="SecurityName" required placeholder="Örn: Apple Inc.">
                    </div>
                    <div class="form-group">
                        <label>GICS Sektörü</label>
                        <input type="text" name="GICS_Sector" placeholder="Örn: Information Technology">
                    </div>
                    <div class="form-group">
                        <label>GICS Alt Sektörü</label>
                        <input type="text" name="GICS_Sub_Industry" placeholder="Örn: Technology Hardware">
                    </div>
                    <div class="form-group">
                        <label>Merkez Konumu</label>
                        <input type="text" name="Headquarters_Location" placeholder="Örn: Cupertino, California">
                    </div>
                    <div class="form-group">
                        <label>CIK No</label>
                        <input type="text" name="CIK" placeholder="Örn: 320193">
                    </div>
                    <div class="form-group">
                        <label>Kuruluş Yılı</label>
                        <input type="text" name="Founded" placeholder="Örn: 1976">
                    </div>
                    <div class="form-group">
                        <label>Sorumlu Kullanıcı</label>
                        <input type="text" name="Sorumlu_Kullanici" placeholder="Örn: Ceren Özkan">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-success">Kaydet</button>
                        <a href="?mod=sirketler" class="btn-cancel">İptal</a>
                    </div>
                </form>
            </div>
        </div>
    </cfif>

    <!-- ŞİRKET DÜZENLEME FORMU -->
    <cfif url.mod eq "duzenle_sirket">
        <div class="card small-card">
            <div class="card-header">
                <h3><i class="fas fa-edit"></i> Düzenle</h3>
            </div>
            <div class="card-body">
                <cfoutput query="qSirket">
                <form method="post" class="grid-form">
                    <input type="hidden" name="is_submitted" value="2">
                    <input type="hidden" name="Symbol" value="#Symbol#">
                    <div class="form-group">
                        <label>Şirket Adı</label>
                        <input type="text" name="SecurityName" value="#SecurityName#">
                    </div>
                    <div class="form-group">
                        <label>GICS Sektör</label>
                        <input type="text" name="GICS_Sector" value="#GICS_Sector#">
                    </div>
                    <div class="form-group">
                        <label>Alt Sektör</label>
                        <input type="text" name="GICS_Sub_Industry" value="#GICS_Sub_Industry#">
                    </div>
                    <div class="form-group">
                        <label>Merkez</label>
                        <input type="text" name="Headquarters_Location" value="#Headquarters_Location#">
                    </div>
                    <div class="form-group">
                        <label>CIK</label>
                        <input type="text" name="CIK" value="#CIK#">
                    </div>
                    <div class="form-group">
                        <label>Kuruluş</label>
                        <input type="text" name="Founded" value="#Founded#">
                    </div>
                    <div class="form-group">
                        <label>Sorumlu</label>
                        <input type="text" name="Sorumlu_Kullanici" value="#Sorumlu_Kullanici#">
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn-success">Güncelle</button>
                        <a href="?mod=sirketler" class="btn-cancel">İptal</a>
                    </div>
                </form>
                </cfoutput>
            </div>
        </div>
    </cfif>

</div>

</body>
</html>