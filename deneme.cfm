<cfcontent type="text/html; charset=utf-8">
<cfset setEncoding("form","utf-8")>
<cfset setEncoding("url","utf-8")>

<cfparam name="url.mod" default="">

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="utf-8">
    <title>Sistem Yönetim Paneli</title>

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<div class="container-fluid">

    <!-- BAŞLIK -->
    <h2 class="main-title">
        <i class="fas fa-database"></i>
        Veri Yönetim Sistemi
    </h2>

    <!-- DASHBOARD -->
    <div class="filter-dashboard">
        <a href="?mod=sirketler"
           class="filter-card <cfif url.mod eq 'sirketler'>active</cfif>">
            <i class="fas fa-building fa-2x"></i>
            <strong>Şirketler</strong>
        </a>

        <a href="?mod=kullanicilar"
           class="filter-card <cfif url.mod eq 'kullanicilar'>active</cfif>">
            <i class="fas fa-users fa-2x"></i>
            <strong>Kullanıcılar</strong>
            <small>Sistem Kayıtlı Tüm Kişiler</small>
        </a>

        <a href="?mod=eslesenler"
           class="filter-card <cfif url.mod eq 'eslesenler'>active</cfif>">
            <i class="fas fa-handshake fa-2x"></i>
            <strong>Şirketlerin Sorumlu Kullanıcıları</strong>
            <small>Sorumlusu Atanmışlar</small>
        </a>
    </div>

    <!-- BOŞ EKRAN -->
    <cfif url.mod eq "">
        <div class="welcome-box">
            <i class="fas fa-mouse-pointer fa-3x"></i>
            <p>Lütfen yukarıdan bir modül seçiniz.</p>
        </div>
    </cfif>

    <!-- ŞİRKETLER -->
    <cfif url.mod eq "sirketler">
        <cfquery name="qSirketler" datasource="SitemDB">
            SELECT
                Symbol,
                SecurityName,
                GICS_Sector,
                GICS_Sub_Industry,
                Sorumlu_Kullanici,
                Headquarters_Location,
                DateAdded,
                CIK,
                Founded
            FROM dbo.COMPANY
            ORDER BY SecurityName
        </cfquery>

        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-list"></i>
                    Tüm Şirket Listesi
                    <span class="count-badge">
                        #qSirketler.RecordCount# kayıt
                    </span>
                </h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Sembol</th>
                            <th>Şirket</th>
                            <th>Sektör</th>
                            <th>Alt Sektör</th>
                            <th>Sorumlu Kişi</th>
                            <th>Merkez</th>
                            <th>Eklenme Tarihi</th>
                            <th>CIK</th>
                            <th>Kuruluş Tarihi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qSirketler">
                        <tr>
                            <td><span class="id-tag">#Symbol#</span></td>
                            <td><strong>#SecurityName#</strong></td>
                            <td>#GICS_Sector#</td>
                            <td>#GICS_Sub_Industry#</td>
                            <td>
                                <span class="status success">
                                    #Sorumlu_Kullanici#
                                </span>
                            </td>
                            <td>#Headquarters_Location#</td>
                            <td>#DateFormat(DateAdded,"dd.mm.yyyy")#</td>
                            <td>#CIK#</td>
                            <td>#Founded#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

    <!-- KULLANICILAR -->
    <cfif url.mod eq "kullanicilar">
        <cfquery name="qKullanicilar" datasource="SitemDB">
            SELECT ID, Isim, KayitTarihi
            FROM dbo.Kullanicilar
            ORDER BY Isim
        </cfquery>

        <div class="card small-card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-users"></i>
                    Kayıtlı Kullanıcılar
                </h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Ad Soyad</th>
                            <th>Kayıt Tarihi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qKullanicilar">
                        <tr>
                            <td><span class="id-tag">#ID#</span></td>
                            <td>#Isim#</td>
                            <td>#DateFormat(KayitTarihi,"dd.mm.yyyy")#</td>
                        </tr>
                        </cfoutput>
                    </tbody>
                </table>
            </div>
        </div>
    </cfif>

    <!-- EŞLEŞENLER -->
    <cfif url.mod eq "eslesenler">
        <cfquery name="qEslesen" datasource="SitemDB">
            SELECT
                C.Symbol,
                C.SecurityName,
                K.Isim,
                K.KayitTarihi
            FROM dbo.COMPANY C
            INNER JOIN dbo.Kullanicilar K
                ON LTRIM(RTRIM(C.Sorumlu_Kullanici))
                 = LTRIM(RTRIM(K.Isim))
            ORDER BY C.SecurityName
        </cfquery>

        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-check-double"></i>
                    Eşleşen Kayıtlar
                </h3>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Symbol</th>
                            <th>Şirket</th>
                            <th>Sorumlu</th>
                            <th>Kayıt Tarihi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfoutput query="qEslesen">
                        <tr>
                            <td><span class="id-tag">#Symbol#</span></td>
                            <td>#SecurityName#</td>
                            <td><span class="status success">#Isim#</span></td>
                            <td>#DateFormat(KayitTarihi,"dd.mm.yyyy")#</td>
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
