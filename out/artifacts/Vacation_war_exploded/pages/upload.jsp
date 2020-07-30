<%@ page import="bean.User" %>
<%@ page import="bean.Photo" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>Upload</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/css/bootstrap.min.css">
    <script src="<%=request.getContextPath()%>/src/jquery-3.5.1/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath()%>/src/bootstrap-4.5.0-dist/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/src/CSS/upload.css">
    <script>
        function uploadImage(file, preview) {
            var div = document.getElementById(preview);
            var label = document.getElementsByTagName("label").item(0);
            label.innerText = getFileName(file);
            if (file.files && file.files[0]) {
                div.innerHTML = '<img id="upload-image">';
                let format = getFileFormat(file);
                var img = document.getElementById("upload-image");
                img.onload = function () {
                    img.style.width = "50%";
                };
                if (format !== "jpg" && format !== "jpeg" && format !== "png" && format !== "gif" && format !== "bmp") {
                    img.style.display = "none";
                }
                var reader = new FileReader();
                reader.onload = function (evt) {
                    img.src = evt.target.result;
                };
                reader.readAsDataURL(file.files[0]);
            }
        }

        function getFileName(file) {
            let index = file.value.lastIndexOf("\\");
            return file.value.substring(index + 1);
        }

        function getFileFormat(file) {
            let index = file.value.lastIndexOf(".");
            return file.value.substring(index + 1).toLowerCase();
        }
    </script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#"><img src="<%=request.getContextPath()%>/src/images/html-images/logo.png" width="35"
                                          height="35" alt="logo"/></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/index">Home</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/search">Search</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <%
                if (session.getAttribute("User") == null) {
            %>
            <li class="nav-item">
                <a class="nav-link" href="<%=request.getContextPath()%>/login">Login</a>
            </li>
            <%
            } else {
            %>
            <li class="dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false"><%=((User) session.getAttribute("User")).getUserName()%>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/favor">Favor</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/photo">Photo</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/friend">Friend</a>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/upload">Upload</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="<%=request.getContextPath()%>/LogoutService">Logout</a>
                </div>
            </li>
            <%
                }
            %>
        </ul>
    </div>
</nav>
<div id="information-container"></div>
<%
    boolean ifUpload = request.getAttribute("Photo") == null;
    Photo photo = null;
    if (!ifUpload) photo = (Photo) request.getAttribute("Photo");
%>
<section>
    <h4 class="strong"><%=(ifUpload) ? "Upload" : "Modify"%>
    </h4>
    <div class="dropdown-divider"></div>
    <form method="post" action="<%=request.getContextPath()%>/<%=(ifUpload) ? "Upload" : "Modify"%>Service"
          enctype="multipart/form-data" onsubmit="return checkForm();">
        <%=(ifUpload) ? "" : "<input type=\"hidden\" name=\"id\" value=\"" + photo.getImageID() + "\">"%>
        <div id="picture_upload">
            <div id="preview">
                <%
                    if (ifUpload) {
                %>
                Upload your photo here.
                <%
                } else {
                %>
                <img style="width: 50%;"
                     src="<%=request.getContextPath()%>/src/images/travel-images/large/<%=photo.getPath()%>">
                <%
                    }
                %>
            </div>
            <p class="upload-container custom-file">
                <input type="file" name="photo" class="custom-file-input" onchange=uploadImage(this,"preview");>
                <label class="custom-file-label"></label>
            </p>
        </div>
        <div id="picture_detail">
            <p>Photo Title</p>
            <input type="text" name="title" class="form-control" value="<%=(ifUpload) ? "" : photo.getTitle()%>">
            <p>Photo Content</p>
            <input type="text" name="content" class="form-control" value="<%=(ifUpload) ? "" : photo.getContent()%>">
            <p>Photo Description</p>
            <textarea name="description" class="form-control"
                      rows="5"><%=(ifUpload) ? "" : photo.getDescription()%></textarea>
            <p>Shooting Place</p>
            <select name="country" onchange="selectCityByCountry(this,this.form.city);">
                <option value="0">Shooting Country</option>
            </select>
            <select name="city">
                <option value="0">Shooting City</option>
            </select>
            <br><input type="button" value="<%=(ifUpload) ? "Upload" : "Modify"%>" class="btn btn-outline-success"
                       data-toggle="modal" data-target="#upload-confirm" data-whatever="@mdo">
            <div class="modal fade" id="upload-confirm" tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-body">
                            Are you sure to <strong><%=(ifUpload) ? "upload" : "modify"%>
                        </strong> this photo?
                        </div>
                        <div class="modal-footer">
                            <input type="button" value="Cancel" class="btn btn-outline-primary btn-confirm"
                                   data-dismiss="modal" id="cancel">
                            <input type="submit" value="Yes" class="btn btn-outline-danger btn-confirm">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</section>
<script>
    cities = {};
    cities["China"] = ["Shanghai", "Zhumadian", "Beijing", "Nanchong", "Tai'an", "Yueyang", "Kaifeng", "Wuhan", "Chongqing", "Chengdu", "Tianjin", "Puyang", "Shenyang", "Shiyan", "Harbin", "Xi'an", "Lanzhou", "Guangzhou", "Nanjing", "Shenzhen", "Taiyuan", "Yunfu", "Changchun", "Zhongshan", "Changsha", "Jinan", "Dalian", "Zhengzhou", "Shijiazhuang", "Ordos"];
    cities["India"] = ["Mumbai", "Delhi", "Bangalore", "Kolkata", "Chennai", "Ahmadabad", "Hyderabad", "Pune", "Surat", "Kanpur", "Jaipur", "Navi Mumbai", "Lucknow", "Nagpur", "Raigarh Fort", "Indore", "Patna", "Bhopal", "Ludhiana", "Agra", "Vadodara", "Gorakhpur", "Nasik", "Pimpri", "Kalyan", "Thane", "Meerut", "Faridabad", "Ghaziabad", "Dombivli"];
    cities["United States"] = ["New York City", "Los Angeles", "Chicago", "Brooklyn", "Houston", "Philadelphia", "Manhattan", "Phoenix", "Borough of Bronx", "San Antonio", "San Diego", "Dallas", "San Jose", "Indianapolis", "Jacksonville", "San Francisco", "Austin", "Columbus", "Fort Worth", "Charlotte", "Detroit", "El Paso", "Memphis", "New South Memphis", "Baltimore", "Boston", "Seattle", "Washington, D. C.", "Denver", "Milwaukee"];
    cities["Indonesia"] = ["Jakarta", "Surabaya", "Medan", "Bandung", "Bekasi", "Palembang", "Tangerang", "Makassar", "Semarang", "Depok", "Masjid Jamie Baitul Muttaqien", "Mamuju", "Padang", "Bandarlampung", "Bogor", "Malang", "Pekanbaru", "City of Balikpapan", "Yogyakarta", "Situbondo", "Banjarmasin", "Surakarta", "Cimahi", "Pontianak", "Manado", "Balikpapan", "Jambi", "Denpasar", "Ambon", "Samarinda"];
    cities["Brazil"] = ["Sao Paulo", "Rio de Janeiro", "Salvador", "Fortaleza", "Belo Horizonte", "Brasilia", "Curitiba", "Manaus", "Recife", "Belem", "Porto Alegre", "Goiania", "Guarulhos", "Campinas", "Nova Iguacu", "Maceio", "Sao Luis", "Duque de Caxias", "Natal", "Teresina", "Sao Bernardo do Campo", "Campo Grande", "Jaboatao", "Osasco", "Santo Andre", "Joao Pessoa", "Jaboatao dos Guararapes", "Contagem", "Sao Jose dos Campos", "Uberlandia"];
    cities["Pakistan"] = ["Karachi", "Lahore", "Faisalabad", "Rawalpindi", "Multan", "Hyderabad", "Gujranwala", "Peshawar", "Quetta", "Kotli", "Islamabad", "Bahawalpur", "Sargodha", "Sialkot", "Sukkur", "Larkana", "Sheikhupura", "Bhimbar", "Jhang Sadr", "Gujrat", "Mardan", "Malir Cantonment", "Kasur", "Dera Ghazi Khan", "Montgomery", "Nawabshah", "Mingaora", "Okara", "Mirpur Khas", "Chiniot"];
    cities["Bangladesh"] = ["Dhaka", "Chittagong", "Khulna", "Rajshahi", "Comilla", "Tungi", "Rangpur", "Narsingdi", "Cox's Bazar", "Jessore", "Nagarpur", "Sylhet", "Mymensingh", "Narayanganj", "Bogra", "Dinajpur", "Barisal", "Saidpur", "Par Naogaon", "Tangail", "Jamalpur", "Nawabganj", "Pabna", "Kushtia", "Satkhira", "Sirajganj", "Faridpur", "Sherpur", "Bhairab Bazar", "Shahzadpur"];
    cities["Nigeria"] = ["Lagos", "Kano", "Ibadan", "Kaduna", "Port Harcourt", "Benin City", "Maiduguri", "Zaria", "Aba", "Jos", "Ilorin", "Oyo", "Enugu", "Abeokuta", "Abuja", "Sokoto", "Onitsha", "Warri", "Calabar", "Katsina", "Akure", "Bauchi", "Ebute Ikorodu", "Makurdi", "Minna", "Effon Alaiye", "Ilesa", "Owo", "Umuahia", "Ondo"];
    cities["Russia"] = ["Moscow", "Saint Petersburg", "Gorod Belgorod", "Novosibirsk", "Yekaterinburg", "Nizhniy Novgorod", "Samara", "Omsk", "Kazan", "Rostov-na-Donu", "Chelyabinsk", "Ufa", "Volgograd", "Perm'", "Krasnoyarsk", "Saratov", "Voronezh", "Tol'yatti", "Krasnodar", "Ul'yanovsk", "Izhevsk", "Yaroslavl'", "Barnaul", "Vladivostok", "Irkutsk", "Khabarovsk", "Khabarovsk Vtoroy", "Orenburg", "Novokuznetsk", "Ryazan'"];
    cities["Japan"] = ["Tokyo", "Yokohama-shi", "Osaka-shi", "Nagoya-shi", "Sapporo-shi", "Kobe-shi", "Kyoto", "Fukuoka-shi", "Kawasaki", "Saitama", "Hiroshima-shi", "Yono", "Sendai-shi", "Kitakyushu", "Chiba-shi", "Sakai", "Shizuoka-shi", "Nerima", "Kumamoto-shi", "Sagamihara", "Okayama-shi", "Hamamatsu", "Hachioji", "Funabashi", "Kagoshima-shi", "Niigata-shi", "Himeji", "Matsudo", "Nishinomiya", "Kawaguchi"];
    cities["Mexico"] = ["Mexico City", "Iztapalapa", "Ecatepec", "Guadalajara", "Puebla de Zaragoza", "Ciudad Juarez", "Tijuana", "Ciudad Nezahualcoyotl", "Gustavo A. Madero", "Gustavo A. Madero", "Monterrey", "Leon", "Zapopan", "Naucalpan de Juarez", "Guadalupe", "Merida", "Tlalnepantla", "Chihuahua", "Alvaro Obregon", "San Luis Potosi", "Aguascalientes", "Acapulco de Juarez", "Coyoacan", "Saltillo", "Santiago de Queretaro", "Tlalpan", "Mexicali", "Hermosillo", "Morelia", "Culiacan"];
    cities["Philippines"] = ["Manila", "Quezon City", "Budta", "Davao", "Malingao", "Cebu City", "General Santos", "Taguig", "Pasig City", "Antipolo", "Makati City", "Zamboanga", "Bacolod City", "Mansilingan", "Cagayan de Oro", "Dasmarinas", "Iloilo", "San Jose del Monte", "Bacoor", "Calamba", "Iligan City", "Mandaluyong City", "Angeles City", "Santol", "Mandaue City", "Cainta", "Baguio", "San Pedro", "Mantampay", "San Fernando"];
    cities["Vietnam"] = ["Thanh pho Ho Chi Minh", "Ha Noi", "Turan", "Haiphong", "Bien Hoa", "Hue", "Nha Trang", "Can Tho", "Rach Gia", "Quy Nhon", "Vung Tau", "Da Lat", "Nam Dinh", "Vinh", "Phan Thiet", "Lagi", "Long Xuyen", "Can Duoc", "Ha Long", "Buon Ma Thuot", "Cam Ranh", "Sa Pa", "Cam Pha Mines", "Thai Nguyen", "My Tho", "Soc Trang", "Pleiku", "Thanh Hoa", "Ca Mau", "Thanh pho Bac Lieu"];
    cities["Ethiopia"] = ["Addis Ababa", "Dire Dawa", "Mekele", "Nazret", "Bahir Dar", "Gonder", "Dese", "Hawassa", "Jima", "Debre Zeyit", "Kombolcha", "Harar", "Shashemene", "Arba Minch'", "Adigrat", "Debre Mark'os", "Debre Birhan", "Jijiga", "Inda Silase", "Ziway", "Dila", "Hagere Hiywet", "Gambela", "Aksum", "Giyon", "Yirga `Alem", "Mojo", "Goba", "Shakiso", "Felege Neway"];
    cities["Germany"] = ["Berlin", "Hamburg", "Muenchen", "Koeln", "Frankfurt am Main", "Essen", "Stuttgart", "Dortmund", "Dusseldorf", "Bremen", "Hannover", "Leipzig", "Duisburg", "Nuremberg", "Dresden", "Wandsbek", "Bochum", "Bochum-Hordel", "Wuppertal", "Berlin Pankow", "Bielefeld", "Berlin Mitte", "Berlin Wilmersdorf", "Bonn", "Mannheim", "Berlin Steglitz Zehlendorf", "Marienthal", "Karlsruhe", "Hamburg-Nord", "Wiesbaden"];
    cities["Egypt"] = ["Cairo", "Alexandria", "Al Jizah", "Port Said", "Suez", "Al Mahallah al Kubra", "Luxor", "Asyut", "Al Mansurah", "Tanda", "Al Fayyum", "Az Zaqaziq", "Ismailia", "Kafr ad Dawwar", "Aswan", "Qina", "Halwan", "Damanhur", "Al Minya", "Suhaj", "Bani Suwayf", "Banha", "Idfu", "Talkha", "Kafr ash Shaykh", "Mallawi", "Dikirnis", "Bilbays", "Al `Arish", "Jirja"];
    cities["Turkey"] = ["Istanbul", "Ankara", "Izmir", "Bursa", "Adana", "Gaziantep", "Konya", "Cankaya", "Antalya", "Bagcilar", "Diyarbakir", "Kayseri", "UEskuedar", "Bahcelievler", "Umraniye", "Mercin", "Esenler", "Eskisehir", "Karabaglar", "Sanliurfa", "Malatya", "Sultangazi", "Maltepe", "Erzurum", "Samsun", "Kahramanmaras", "Van", "Atasehir", "Sisli", "Denizli"];
    cities["Iran"] = ["Tehran", "Mashhad", "Esfahan", "Karaj", "Tabriz", "Shiraz", "Qom", "Ahvaz", "Kahriz", "Kermanshah", "Rasht", "Kerman", "Orumiyeh", "Zahedan", "Hamadan", "Azadshahr", "Arak", "Yazd", "Ardabil", "Abadan", "Zanjan", "Bandar 'Abbas", "Sanandaj", "Qazvin", "Khorramshahr", "Khorramabad", "Khomeyni Shahr", "Kashan", "Shari-i-Tajan", "Borujerd"];
    cities["Democratic Republic of the Congo"] = ["Kinshasa", "Lubumbashi", "Mbuji-Mayi", "Kisangani", "Masina", "Kananga", "Likasi", "Kolwezi", "Tshikapa", "Bukavu", "Mwene-Ditu", "Kikwit", "Mbandaka", "Matadi", "Uvira", "Butembo", "Gandajika", "Kalemie", "Goma", "Kindu", "Isiro", "Bandundu", "Gemena", "Ilebo", "Bunia", "Bumba", "Beni", "Mbanza-Ngungu", "Kamina", "Lisala"];
    cities["Thailand"] = ["Bangkok", "Samut Prakan", "Mueang Nonthaburi", "Udon Thani", "Chon Buri", "Nakhon Ratchasima", "Chiang Mai", "Hat Yai", "Pak Kret", "Si Racha", "Phra Pradaeng", "Lampang", "Khon Kaen", "Surat Thani", "Ban Rangsit", "Ubon Ratchathani", "Nakhon Si Thammarat", "Khlong Luang", "Nakhon Pathom", "Rayong", "Phitsanulok", "Chanthaburi", "Phatthaya", "Yala", "Ratchaburi", "Nakhon Sawan", "Phuket", "Ban Mai", "Songkhla", "Phra Nakhon Si Ayutthaya"];
    cities["France"] = ["Paris", "Marseille", "Lyon", "Toulouse", "Nice", "Nantes", "Strasbourg", "Montpellier", "Bordeaux", "Lille", "Rennes", "Reims", "Le Havre", "Saint-Etienne", "Toulon", "Angers", "Grenoble", "Dijon", "Nimes", "Aix-en-Provence", "Brest", "Le Mans", "Amiens", "Tours", "Limoges", "Clermont-Ferrand", "Villeurbanne", "Besancon", "Orleans", "Metz"];
    cities["United Kingdom"] = ["City of London", "London", "Birmingham", "Glasgow", "Liverpool", "Leeds", "Sheffield", "Edinburgh", "Bristol", "Manchester", "Leicester", "Islington", "Coventry", "Hull", "Cardiff", "Bradford", "Belfast", "Stoke-on-Trent", "Wolverhampton", "Plymouth", "Nottingham", "Southampton", "Reading", "Derby", "Bexley", "Dudley", "Northampton", "Portsmouth", "Luton", "Newcastle upon Tyne"];
    cities["Italy"] = ["Roma", "Milano", "Napoli", "Turin", "Palermo", "Genova", "Firenze", "Bologna", "Bari", "Catania", "Venezia", "Verona", "Messina", "Trieste", "Padova", "Taranto", "Brescia", "Reggio Calabria", "Mestre", "Modena", "Prato", "Cagliari", "Parma", "Livorno", "Foggia", "Perugia", "Reggio nell'Emilia", "Salerno", "Ravenna", "Ferrara"];
    cities["Myanmar"] = ["Rangoon", "Mandalay", "Nay Pyi Taw", "Mawlamyine", "Bago", "Pathein", "Monywa", "Sittwe", "Meiktila", "Myeik", "Taunggyi", "Myingyan", "Dawei", "Pyay", "Hinthada", "Lashio", "Pakokku", "Thaton", "Maymyo", "Yenangyaung", "Taungoo", "Thayetmyo", "Pyinmana", "Magway", "Myitkyina", "Chauk", "Mogok", "Nyaunglebin", "Mudon", "Shwebo"];
    cities["South Africa"] = ["Cape Town", "Durban", "Johannesburg", "Soweto", "Pretoria", "Port Elizabeth", "Pietermaritzburg", "Benoni", "Tembisa", "East London", "Vereeniging", "Bloemfontein", "Boksburg", "Welkom", "Newcastle", "Krugersdorp", "Botshabelo", "Brakpan", "Witbank", "Richards Bay", "Vanderbijlpark", "Centurion", "Uitenhage", "Roodepoort", "Noorder-Paarl", "Springs", "Carletonville", "Klerksdorp", "George", "Midrand"];
    cities["South Korea"] = ["Seoul", "Busan", "Incheon", "Daegu", "Daejeon", "Gwangju", "Suigen", "Goyang", "Seongnam", "Ulsan", "Bucheon", "Jeonju", "Ansan", "Cheongju", "Anyang", "Changwon", "Hoko", "Vijongbu", "Hwaseong", "Jeju", "Tenan", "Kwangmyong", "Kimhae", "Masan", "Reisui", "Chinju", "Kumi", "Iksan", "Moppo", "Kunsan"];
    cities["Spain"] = ["Madrid", "Barcelona", "Valencia", "Sevilla", "Zaragoza", "Malaga", "Murcia", "Palma", "Las Palmas de Gran Canaria", "Bilbao", "Alicante", "Cordoba", "Valladolid", "Vigo", "Gijon", "Eixample", "L'Hospitalet de Llobregat", "Latina", "Carabanchel", "A Coruna", "Puente de Vallecas", "Vitoria-Gasteiz", "Granada", "Elche", "Ciudad Lineal", "Oviedo", "Santa Cruz de Tenerife", "Sant Marti", "Fuencarral-El Pardo", "Badalona"];
    cities["Ukraine"] = ["Kiev", "Kharkiv", "Dnipropetrovsk", "Donets'k", "Odessa", "Zaporizhzhya", "L'viv", "Kryvyy Rih", "Mykolayiv", "Mariupol'", "Luhans'k", "Khmel'nyts'kyy", "Sevastopol'", "Makiyivka", "Simferopol'", "Vinnytsya", "Kherson", "Poltava", "Chernihiv", "Cherkasy", "Sumy", "Zhytomyr", "Horlivka", "Rivne", "Kirovohrad", "Dniprodzerzhyns'k", "Chernivtsi", "Ternopil'", "Kremenchuk", "Luts'k"];
    cities["Colombia"] = ["Bogota", "Cali", "Medellin", "Barranquilla", "Cartagena", "Cucuta", "Bucaramanga", "Pereira", "Santa Marta", "Ibague", "Bello", "Pasto", "Manizales", "Neiva", "Soledad", "Villavicencio", "Armenia", "Soacha", "Valledupar", "Itagui", "Monteria", "Sincelejo", "Popayan", "Floridablanca", "Palmira", "Buenaventura", "Barrancabermeja", "Dos Quebradas", "Tulua", "Envigado"];
    cities["Tanzania"] = ["Dar es Salaam", "Mwanza", "Zanzibar", "Arusha", "Mbeya", "Morogoro", "Tanga", "Dodoma", "Kigoma", "Moshi", "Tabora", "Songea", "Musoma", "Iringa", "Katumba", "Shinyanga", "Mtwara", "Ushirombo", "Kilosa", "Sumbawanga", "Bagamoyo", "Mpanda", "Bukoba", "Singida", "Uyovu", "Makumbako", "Buseresere", "Bunda", "Merelani", "Katoro"];
    var countrySelect = document.getElementsByName("country").item(0);
    var citySelect = document.getElementsByName("city").item(0);
    for (let key in cities) {
        let option = document.createElement("Option");
        option.value = key;
        option.innerText = key;
        countrySelect.appendChild(option);
    }
    <%
     if (!ifUpload) {
    %>
    for (let i = 0; i < countrySelect.options.length; i++)
        if (countrySelect.options[i].value === "<%=photo.getCountryName()%>") countrySelect.options[i].selected = true;
    selectCityByCountry(countrySelect, citySelect);
    for (let i = 0; i < citySelect.options.length; i++)
        if (citySelect.options[i].value === "<%=photo.getCityName()%>") citySelect.options[i].selected = true;
    <%
     }
    %>

    function selectCityByCountry(country, city) {
        var cty;
        cty = country.value;
        for (var i = 1; i < city.options.length; i++) {
            city.removeChild(city.options[i]);
            city.options.length = 1;
        }
        if (cty == "0") return;
        for (var i = 0; i < cities[cty].length; i++) {
            city.options[i + 1] = new Option();
            city.options[i + 1].text = cities[cty][i];
            city.options[i + 1].value = cities[cty][i];
        }
    }

    function checkForm() {
        informationContainer.innerHTML = "";
        cancelButton.click();
        let ifValid = true;
        if (photo.value === "") {
            <%
            if (ifUpload) {
            %>
            alertMessage("Please upload your photo!");
            ifValid = false;
            <%
            }
            %>
        } else {
            if (photo.files[0].size > 10240000) {
                alertMessage("Photo's size can't be more than 10MB!");
                ifValid = false;
            }
            let format = getFileFormat(photo);
            if (format !== "jpg" && format !== "jpeg" && format !== "png" && format !== "gif" && format !== "bmp") {
                alertMessage("Can't recognize this photo's format!");
                ifValid = false;
            }
        }
        if (title.value === "") {
            alertMessage("Please enter the title!");
            ifValid = false;
        }
        if (content.value === "") {
            alertMessage("Please enter the content!");
            ifValid = false;
        }
        if (country.value === "0") {
            alertMessage("Please select the country!");
            ifValid = false;
        } else if (city.value === "0") {
            alertMessage("Please select the city!");
            ifValid = false;
        }
        return ifValid;
    }

    function alertMessage(message) {
        informationContainer.innerHTML += "<div class=\"alert alert-danger alert-dismissible fade show\" " +
            "style=\"width: 50%; margin: 10px auto 10px auto \"><button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>"
            + message + "</div>";
    }

    var photo = document.getElementsByName("photo").item(0);
    var title = document.getElementsByName("title").item(0);
    var description = document.getElementsByName("description").item(0);
    var content = document.getElementsByName("content").item(0);
    var city = document.getElementsByName("city").item(0);
    var country = document.getElementsByName("country").item(0);
    var informationContainer = document.getElementById("information-container");
    var cancelButton = document.getElementById("cancel");
</script>
</body>
</html>