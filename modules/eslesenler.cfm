<cfquery name="qMatches" datasource="SitemDB">
    SELECT 
        c.Symbol,
        c.SecurityName,
        c.Sorumlu_Kullanici,
        k.Firstname,
        k.Lastname,
        k.Email
    FROM dbo.COMPANY c
    LEFT JOIN dbo.Kullanicilar k ON c.Sorumlu_Kullanici = k.Firstname
    ORDER BY c.SecurityName ASC
</cfquery>

<div class="card">
    <div class="card-header">
        <h3><i class="fas fa-handshake"></i> Şirket - Sorumlu Kullanıcı Eşleşmeleri</h3>
    </div>
    <div class="table-responsive">
        <table>
            <thead>
                <tr>
                    <th>Sembol</th>
                    <th>Şirket Adı</th>
                    <th>Sorumlu (Şirket Kaydı)</th>
                    <th>Eşleşen Kullanıcı</th>
                    <th>E-posta</th>
                    <th>Durum</th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="qMatches">
                <tr>
                    <td><span class="id-tag">#Symbol#</span></td>
                    <td><strong>#SecurityName#</strong></td>
                    <td>#Sorumlu_Kullanici#</td>
                    <td>
                        <cfif len(Firstname)>
                            <i class="fas fa-check-circle" style="color: ##2ecc71;"></i> #Firstname# #Lastname#
                        <cfelse>
                            <i class="fas fa-exclamation-triangle" style="color: ##e74c3c;"></i> <span style="color:##e74c3c; font-size: 0.8em;">Kullanıcı Bulunamadı</span>
                        </cfif>
                    </td>
                    <td>#Email#</td>
                    <td>
                        <cfif len(Firstname)>
                            <span class="status success" style="background: ##d4edda; color: ##155724; padding: 2px 8px; border-radius: 4px;">Aktif</span>
                        <cfelse>
                            <span class="status danger" style="background: ##f8d7da; color: ##721c24; padding: 2px 8px; border-radius: 4px;">Eksik</span>
                        </cfif>
                    </td>
                </tr>
                </cfoutput>
            </tbody>
        </table>
    </div>
</div>