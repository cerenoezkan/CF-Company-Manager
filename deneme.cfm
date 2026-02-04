<cfcontent type="text/html; charset=utf-8">
<cfset setEncoding("form","utf-8")>
<cfset setEncoding("url","utf-8")>

<cfparam name="url.mod" default=""> <!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="utf-8">
    <title>Sistem Yönetim Paneli</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="container-fluid" style="max-width: 1400px; margin: auto; padding: 20px;">
    <h2 style="text-align: center; margin-bottom: 30px;">
        <i class="fas fa-database" style="color: ##2563eb;"></i> Veri Yönetim Sistemi
    </h2>

    <div class="filter-dashboard">
        <a href="?mod=sirketler" class="filter-card <cfif url.mod eq 'sirketler'>active</cfif>">
            <i class="fas fa-building fa-2x"></i>
            <strong>Şirketler</strong>
            <small>Tüm Şirket Verileri</small>
        </a>
        <a href="?mod=kullanicilar" class="filter-card <cfif url.mod eq 'kullanicilar'>active</cfif>">
            <i class="fas fa-users fa-2x"></i>
            <strong>Kullanıcılar</strong>
            <small>Sistem Kayıtlı Kişiler</small>
        </a>
        <a href="?mod=eslesenler" class="filter-card <cfif url.mod eq 'eslesenler'>active</cfif>">
            <i class="fas fa-handshake fa-2x"></i>
            <strong>Eşleşen Kayıtlar</strong>
            <small>Sorumlusu Atanmışlar</small>
        </a>
    </div>

    <div class="divider"></div>

    <cfif url.mod eq "">
        <div class="welcome-box">
            <i class="fas fa-mouse-pointer fa-3x"></i>
            <p>Lütfen işlem yapmak için yukarıdaki panellerden birini seçiniz.</p>
        </div>
    </cfif>

    <cfif url.mod eq "sirketler">
        <cfquery name="qSirketler" datasource="SitemDB">
            SELECT Symbol, SecurityName, GICS_Sector, GICS_Sub_Industry, Headquarters_Location, DateAdded, CIK, Founded, Sorumlu_Kullanici 
            FROM dbo.COMPANY 
            ORDER BY SecurityName
        </cfquery>
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-list"></i> Tüm Şirket Listesi (#qSirketler.RecordCount# Satır)</h3>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Symbol</th>
                            <th>Şirket Adı</th>
                            <th>Sektör</th>
                            <th>Alt Sektör</th>
                            <th>Merkez</th>
                            <th>Eklenme</th>
                            <th>CIK</th>
                            <th>Kuruluş</th>
                            <th>Sorumlu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qSirketler">
                        <tr>
                            <td><span class="id-tag">#Symbol#</span></td>
                            <td><strong>#SecurityName#</strong></td>
                            <td><small>#GICS_Sector#</small></td>
                            <td><small>#GICS_Sub_Industry#</small></td>
                            <td>#Headquarters_Location#</td>
                            <td>#DateAdded#</td>
                            <td>#CIK#</td>
                            <td>#Founded#</td>
                            <td style="color:##2563eb; font-weight:600;">#Sorumlu_Kullanici#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

    <cfif url.mod eq "kullanicilar">
        <cfquery name="qKullanicilar" datasource="SitemDB">
            SELECT ID, Isim, KayitTarihi FROM dbo.Kullanicilar ORDER BY Isim
        </cfquery>
        <div class="card" style="max-width: 800px; margin: auto;">
            <div class="card-header">
                <h3><i class="fas fa-user-friends"></i> Kayıtlı Kullanıcı Veritabanı</h3>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Kullanıcı Adı</th>
                            <th>Kayıt Tarihi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qKullanicilar">
                        <tr>
                            <td>## #ID#</td>
                            <td><strong>#Isim#</strong></td>
                            <td>#DateFormat(KayitTarihi, "dd.mm.yyyy")#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

    <cfif url.mod eq "eslesenler">
        <cfquery name="qEslesen" datasource="SitemDB">
            SELECT C.Symbol, C.SecurityName, K.Isim, K.KayitTarihi
            FROM dbo.COMPANY C
            INNER JOIN dbo.Kullanicilar K ON LTRIM(RTRIM(C.Sorumlu_Kullanici)) = LTRIM(RTRIM(K.Isim))
            ORDER BY C.SecurityName
        </cfquery>
        <div class="card">
            <div class="card-header">
                <h3><i class="fas fa-check-double"></i> Eşleşen Şirket & Kullanıcı Bilgisi</h3>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Symbol</th>
                            <th>Şirket Adı</th>
                            <th>Sistemdeki Sorumlu</th>
                            <th>Kullanıcı Kayıt Tarihi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qEslesen">
                        <tr>
                            <td><span class="id-tag">#Symbol#</span></td>
                            <td>#SecurityName#</td>
                            <td><span class="status success">#Isim#</span></td>
                            <td>#DateFormat(KayitTarihi, "dd.mm.yyyy")#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

</div>
</body>
</html>