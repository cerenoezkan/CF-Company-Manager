<cfparam name="url.secilen_sirket" default="">

<style>
    :root {
        --primary: #2563eb;
        --secondary: #64748b;
        --success: #22c55e;
        --warning: #f59e0b;
        --danger: #ef4444;
        --bg: #f8fafc;
        --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
    }

    body { background: var(--bg); font-family: 'Inter', system-ui, sans-serif; color: #1e293b; line-height: 1.5; }
    .container-fluid { max-width: 1000px; margin: auto; padding: 40px 20px; }

    /* Kart Tasarımları */
    .glass-card {
        background: white;
        border-radius: 20px;
        padding: 30px;
        margin-bottom: 30px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        box-shadow: var(--card-shadow);
    }

    .card-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: #0f172a;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    /* Grid Form Yapısı */
    .grid-form { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
    
    .form-control {
        width: 100%;
        padding: 12px 16px;
        border-radius: 12px;
        border: 2px solid #e2e8f0;
        transition: all 0.3s ease;
        font-size: 0.95rem;
    }

    .form-control:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        outline: none;
    }

    /* --- İNTERAKTİF YILDIZ SİSTEMİ --- */
    .rating-group {
        background: #f1f5f9;
        padding: 15px;
        border-radius: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .rating-stars label {
    font-size:28px;
    color:#cbd5e1;
    cursor:pointer;
    display:inline-block;
    line-height:1;
    }
    .rating-stars{
    display:flex;
    flex-direction:row-reverse;
    align-items:center;
    }

    .rating-label { font-weight: 600; color: #475569; font-size: 0.9rem; }

    .rating-stars { display: flex; flex-direction: row-reverse; gap: 4px; }
    
    .rating-stars input { display: none; }
    
    .rating-stars label {
        font-size: 28px;
        color: #cbd5e1;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    /* Yıldızların Seçilme ve Üzerine Gelme Efekti */
    .rating-stars input:checked ~ label,
    .rating-stars label:hover,
    .rating-stars label:hover ~ label { color: var(--warning); transform: scale(1.1); }

    /* Özet Panel İstatistikleri */
    .score-display { font-size: 3.5rem; font-weight: 800; line-height: 1; margin-bottom: 5px; }
    .progress-bar-bg { background: #e2e8f0; height: 8px; border-radius: 4px; overflow: hidden; margin-top: 5px; }
    .progress-fill { height: 100%; transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1); }

    .btn-submit {
        background: var(--primary);
        color: white;
        border: none;
        padding: 16px 30px;
        border-radius: 12px;
        font-weight: 700;
        cursor: pointer;
        transition: all 0.3s;
        width: 100%;
        font-size: 1rem;
    }

    .btn-submit:hover { transform: translateY(-2px); background: #1d4ed8; box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3); }
    .rating-stars label{
    all:unset;
    font-size:28px;
    cursor:pointer;
    color:#cbd5e1;
    }

</style>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<cfif structKeyExists(form, "is_submitted") AND form.is_submitted eq "yorum_ekle">
    <cfquery datasource="SitemDB">
        INSERT INTO dbo.Yorumlar (
            SirketSymbol, KullaniciAdi, IsimGizli, PuanGenel, PuanMaas, 
            PuanYanHaklar, PuanRekabet, PuanDenge, PuanYonetim, PuanGelisim, YorumMetni, KayitTarihi
        ) VALUES (
            <cfqueryparam value="#form.SirketSymbol#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.KullaniciAdi#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#structKeyExists(form, 'IsimGizli') ? 1 : 0#" cfsqltype="cf_sql_bit">,
            <cfqueryparam value="#form.PuanGenel#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanMaas#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanYanHaklar#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanRekabet#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanDenge#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanYonetim#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.PuanGelisim#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#form.YorumMetni#" cfsqltype="cf_sql_longvarchar">,
            GETDATE()
        )
    </cfquery>
    <cflocation url="?mod=yorumlar&secilen_sirket=#form.SirketSymbol#" addtoken="false">
</cfif>

<div class="container-fluid">
    <cfquery name="qSirketler" datasource="SitemDB">
        SELECT Symbol, SecurityName FROM dbo.COMPANY ORDER BY SecurityName
    </cfquery>

    <div class="glass-card">
        <div class="card-title"><i class="fas fa-building-circle-check" style="color:var(--primary)"></i> Şirket Değerlendirme Sistemi</div>
        <form method="get">
            <input type="hidden" name="mod" value="yorumlar">
            <select name="secilen_sirket" class="form-control" onchange="this.form.submit()" style="font-weight: 500;">
                <option value="">İncelemek istediğiniz şirketi seçin...</option>
                <cfoutput query="qSirketler">
                    <option value="#Symbol#" <cfif url.secilen_sirket eq Symbol>selected</cfif>>#SecurityName# (#Symbol#)</option>
                </cfoutput>
            </select>
        </form>
    </div>

    <cfif len(url.secilen_sirket)>
        
        <cfquery name="qStats" datasource="SitemDB">
            SELECT 
                AVG(CAST(PuanGenel AS FLOAT)) as AvgGenel,
                AVG(CAST(PuanMaas AS FLOAT)) as AvgMaas,
                AVG(CAST(PuanDenge AS FLOAT)) as AvgDenge,
                AVG(CAST(PuanGelisim AS FLOAT)) as AvgGelisim,
                COUNT(YorumID) as ToplamYorum
            FROM dbo.Yorumlar 
            WHERE SirketSymbol = <cfqueryparam value="#url.secilen_sirket#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <cfif qStats.ToplamYorum gt 0>
            <cfoutput>
            <cfset genelSkor = NumberFormat(qStats.AvgGenel, "0.0")>
            <div class="glass-card">
                <div class="grid-form">
                    <div style="text-align: center; border-right: 1px solid ##e2e8f0; padding: 10px;">
                        <div class="score-display #(genelSkor lt 3 ? 'score-low' : (genelSkor lt 4.5 ? 'score-mid' : 'score-high'))#">#genelSkor#</div>
                        <div style="color: ##f59e0b; margin-bottom: 10px; font-size: 1.1rem;">
                            <cfloop from="1" to="5" index="i"><i class="fa#i lte qStats.AvgGenel ? 's' : 'r'# fa-star"></i></cfloop>
                        </div>
                        <div style="font-weight: 600; color: ##64748b;">#qStats.ToplamYorum# Değerlendirme</div>
                    </div>
                    <div>
                        <cfset karneBarlari = [{l="Maaş/Ücret", v=qStats.AvgMaas}, {l="İş-Yaşam Dengesi", v=qStats.AvgDenge}, {l="Kariyer Gelişimi", v=qStats.AvgGelisim}]>
                        <cfloop array="#karneBarlari#" index="b">
                            <div style="margin-bottom: 12px;">
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem; font-weight: 700;">
                                    <span>#b.l#</span><span>#NumberFormat(b.v, "0.0")#</span>
                                </div>
                                <div class="progress-bar-bg">
                                    <div class="progress-fill" style="width: #(b.v/5)*100#%; background: #(b.v lt 2.5 ? '##ef4444' : (b.v lt 4 ? '##f59e0b' : '##22c55e'))#"></div>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                </div>
            </div>
            </cfoutput>
        </cfif>

        <div class="glass-card">
            <div class="card-title"><i class="fas fa-pen-nib" style="color:var(--primary)"></i> Yeni Değerlendirme Yap</div>
            <form method="post">
                <input type="hidden" name="is_submitted" value="yorum_ekle">
                <input type="hidden" name="SirketSymbol" value="<cfoutput>#url.secilen_sirket#</cfoutput>">

                <div class="grid-form">
                    <div class="form-group">
                        <label class="rating-label">Adınız Soyadınız</label>
                        <input type="text" name="KullaniciAdi" class="form-control" placeholder="Örn: Ahmet Yılmaz" required>
                    </div>

                    <div class="form-group" style="display: flex; align-items: flex-end; padding-bottom: 12px;">
                        <label style="cursor: pointer; font-size: 0.9rem; color: var(--secondary); font-weight: 500;">
                            <input type="checkbox" name="IsimGizli" value="1"> İsmimi Anonim Olarak Sakla
                        </label>
                    </div>

                    <cfset kriterler = [
                        {isim="PuanGenel", label="Genel Deneyim", ikon="star"},
                        {isim="PuanMaas", label="Maaş ve Ücret", ikon="wallet"},
                        {isim="PuanYanHaklar", label="Yan Haklar", ikon="gift"},
                        {isim="PuanRekabet", label="İç Rekabet", ikon="bolt"},
                        {isim="PuanDenge", label="İş-Yaşam Dengesi", ikon="scale-balanced"},
                        {isim="PuanYonetim", label="Yönetim Kalitesi", ikon="user-tie"},
                        {isim="PuanGelisim", label="Kariyer Fırsatları", ikon="arrow-up-right-dots"}
                    ]>

                    <cfoutput>
                    <cfloop array="#kriterler#" index="k">
                        <div class="rating-group">
                            <span class="rating-label"><i class="fas fa-#k.ikon#" style="width:20px"></i> #k.label#</span>
                            <div class="rating-stars">
                                <cfloop from="5" to="1" index="i">
                                    <input type="radio" name="#k.isim#" value="#i#" id="#k.isim##i#" required>
                                    <label for="#k.isim##i#">★</label>
                                </cfloop>
                            </div>
                        </div>
                    </cfloop>
                    </cfoutput>

                    <div class="form-group" style="grid-column: span 2;">
                        <label class="rating-label">Detaylı Görüşünüz</label>
                        <textarea name="YorumMetni" class="form-control" rows="5" placeholder="Şirket kültürü, mülakat süreci ve çalışma ortamı hakkında neler söyleyebilirsiniz?" required></textarea>
                    </div>
                </div>

                <div style="margin-top: 30px;">
                    <button type="submit" class="btn-submit">Değerlendirmeyi Paylaş</button>
                </div>
            </form>
        </div>

        <cfquery name="qYorumlar" datasource="SitemDB">
            SELECT * FROM dbo.Yorumlar 
            WHERE SirketSymbol = <cfqueryparam value="#url.secilen_sirket#" cfsqltype="cf_sql_varchar">
            ORDER BY KayitTarihi DESC
        </cfquery>

        <div class="glass-card">
            <div class="card-title"><i class="fas fa-comments" style="color:var(--primary)"></i> Çalışan Deneyimleri (#qYorumlar.recordCount#)</div>
            
            <cfif qYorumlar.recordCount eq 0>
                <div style="text-align: center; color: var(--secondary); padding: 40px;">
                    <i class="fas fa-comment-slash fa-3x" style="margin-bottom: 15px; opacity: 0.2;"></i>
                    <p>Henüz değerlendirme yapılmamış. İlk yorumu siz yapın!</p>
                </div>
            <cfelse>
                <cfoutput query="qYorumlar">
                    <div style="border-left: 5px solid #(PuanGenel lt 3 ? '##ef4444' : (PuanGenel lt 4.5 ? '##2563eb' : '##22c55e'))#; padding: 20px; background: ##fdfdfd; border-radius: 0 15px 15px 0; margin-bottom: 25px; border-bottom: 1px solid ##f1f5f9;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <strong style="color: ##1e293b; font-size: 1.05rem;">
                                <cfif IsimGizli eq 1>👤 Anonim Kullanıcı<cfelse>👤 #KullaniciAdi#</cfif>
                            </strong>
                            <span style="font-size: 0.85rem; color: ##94a3b8; font-weight: 500;">#DateFormat(KayitTarihi, "dd mmm yyyy")#</span>
                        </div>
                        
                        <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 15px;">
                            <span style="background: ##fef3c7; color: ##92400e; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">
                                Genel: #PuanGenel# ★
                            </span>
                            <span style="background: ##dcfce7; color: ##166534; padding: 4px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 700;">
                                Maaş: #PuanMaas# ★
                            </span>
                        </div>

                        <p style="line-height: 1.6; color: ##475569; margin: 0;">#YorumMetni#</p>
                    </div>
                </cfoutput>
            </cfif>
        </div>
    </cfif>
</div>