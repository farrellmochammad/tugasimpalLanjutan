
// yang belum : menu , parkir -> telah parkir;
uses crt;

type RFID=record
	idRFID : integer;
end;

type Member=record
	idMember 	: integer;
	idRFID	 	: RFID;
	namaMember 	: string;
end;

type NonMember=record
	idStruk		: integer;
	namaNonMember: string;
end;

type Jam=record
	jam 		: integer;
	menit 		: integer;
	detik 		: integer;
end;

type Parkir=record
	idParkir	: integer;
	idMember	: integer;
	jamMasuk	: Jam;
	jamKeluar	: Jam;
	platNomor	: string;
	biaya		: integer;
	isMember	: boolean;
end;

type Master=record
	counterIdParkir	: integer;
	member			: array [0..1000] of Member;
	nonMember		: array [0..1000] of NonMember;
	parkir			: array [0..1000] of Parkir;
	telahParkir		: array [0..1000] of Parkir;
end;

var
	counterIdMember			: integer;
	counteridStruk			: integer;
	counterIdRFID			: integer;
	counterNumMember		: integer;
	counterNumNonMember		: integer;
	counterNumParkir		: integer;
	counterNumTelahParkir	: integer;
	masterProgram			: Master;

procedure startNewProgram();
begin
	counterIdMember			:= 1000;
	counteridStruk			:= 2000;
	counterIdRFID			:= 3000;
	counterNumMember		:= 0;
	counterNumNonMember		:= 0;
	counterNumParkir		:= 0;
	counterNumTelahParkir	:= 0;
end;

procedure tahanBro();
begin
	writeln('tekan tombol apapun , tapi selain tombol power untuk kembali ke menu');
	readln();
end;

function createNewRFID():RFID;
var
	newRFID	: RFID;
begin
	newRFID.idRFID 	:= counterIdRFID;
	counterIdRFID 	:= counterIdRFID + 1;
	createNewRFID 	:= newRFID;
end;

function hitungDurasiParkir(jam1 : Jam; jam2 : Jam): integer;
var
	temp : integer;
begin
	temp := jam2.jam * 3600 + jam2.menit * 60 + jam2.detik;
	temp := temp - jam1.jam * 3600 + jam1.menit * 60 + jam1.detik;
	hitungDurasiParkir := temp div 3600;
end;


//////////////////////////////////////////////////////////////////////////////////
// input data ke master
procedure inputNewMember(newMember : Member);
begin
	masterProgram.member[counterNumMember] := newMember;
	counterNumMember := counterNumMember + 1;
end;

procedure inputNewNonMember(newNonMember : nonMember);
begin
	masterProgram.nonMember[counterNumNonMember] := newNonMember;
	counterNumNonMember := counterNumNonMember + 1;
end;

procedure inputNewParkir(newParkir : parkir);
begin
	masterProgram.parkir[counterNumParkir] := newParkir;
	counterNumParkir := counterNumParkir + 1;
end;

procedure inputNewTelahParkir(newTelahParkir : parkir);
begin
	masterProgram.telahParkir[counterNumTelahParkir] := newTelahParkir;
	counterNumTelahParkir := counterNumTelahParkir + 1;
end;

///////////////////////////////////////////////////////////////////////////////
// fungsi cari data di master
function findIdMember(id : integer):boolean;
var
	i : integer;
	result : boolean;
begin
	result := false;
	if(counterNumMember>=1) then
	begin
		for i:= 0 to counterNumMember-1 do
		begin
			if(masterProgram.member[i].idMember = id ) then
			begin
				result := true;
				break;
			end;
		end;
	end;
	findIdMember := result;
end;

function findStrukNonMember(id : integer):boolean;
var
	i : integer;
	result : boolean;
begin
	result := false;
	if(counterNumNonMember >= 1) then
	begin
		for i:= 0 to counterNumNonMember-1 do
		begin
			if(masterProgram.nonMember[i].idStruk = id ) then
			begin
				result := true;
				break;
			end;
		end;
	end;
	findStrukNonMember := result;
end;

function getPakirObject(idMember : integer):Parkir;
var
	i,j: integer;
	parkirs : Parkir;
begin
	parkirs.idMember := 0;
	// cari objek parkir pada array dengan idMember
	if(counterNumParkir >= 1) then
	begin
		for i:=0 to counterNumParkir-1 do
		begin
			if(idMember = masterProgram.parkir[i].idMember) then
			begin
				parkirs := masterProgram.parkir[i];
				j := i;
				break;
				writeln('ketemu');
			end;
		end;
	
		// delete object parkir pada array of parkir
		// dengan cara geser object ke kiri
		for i:= j to counterNumParkir-2 do
		begin
			masterProgram.parkir[i] := masterProgram.parkir[i+1];
		end;
	

	// pengurangan nilai jumlah parkir
	counterNumParkir := counterNumParkir -1;
	end;
	getPakirObject := parkirs;
end;

////////////////////////////////////////////////////////////////////////////////////////////
// create new objek (anggap aja OO)
procedure createNewMember();
var
	newMember : Member;
begin
	clrscr;
	writeln('---registrasi member baru---');
	write  ('nama member : ');	readln(newMember.namaMember);
	newMember.idRFID 	:= createNewRFID();
	newMember.idMember 	:= counterIdMember;
	
	counterIdMember 	:= counterIdMember + 1;
	writeln('id member : ',newMember.idMember);
	
	//masukan new member ke array di Master;
	inputNewMember(newMember);
	
	writeln();
	writeln('---registrasi member selesai---');
	tahanBro();
end;


function createNewNonMemberObject():integer;
var
	newNonMember : NonMember;
begin
	writeln('-- non Member ---');
	write  ('nama non member : ');	readln(newNonMember.namaNonMember);
	newNonMember.idStruk := counteridStruk;
	counteridStruk := counteridStruk + 1;
	writeln('id struk : ',newNonMember.idStruk);
	writeln();
	writeln('---registrasi non member selesai---');
	tahanBro();
	inputNewNonMember(newNonMember);
	createNewNonMemberObject := newNonMember.idStruk;
end;

procedure createNewParkir();
var
	newParkir : Parkir;
	newJam	: Jam;
	cek,cekb2		: boolean;
	cekChar	: char;
	cekInt,tempInt  : integer;
begin
	clrscr;
	writeln('--- parkir ---');
	write  ('plat nomor : ');	readln(newParkir.platNomor);

	cek := false;
	while(cek = false) do
	begin
		writeln('waktu masuk');
		write('- jam   : ');	readln(newJam.jam);
		write('- detik : ');	readln(newJam.menit);
		write('- menit : ');	readln(newJam.detik);
		if((newJam.jam >= 0)and(newJam.jam <= 24)and(newJam.menit >= 0)and(newJam.menit <= 60)and(newJam.detik >= 0)and(newJam.detik <= 60)) then
			cek:= true
		else
			writeln('inputan jam salah, mohon coba lagi');
	end;
	newParkir.jamMasuk := newJam;
	newParkir.biaya		:= 0;

	write('pelanggan merupakan member ? (y/n)   : '); readln(cekChar);
	if(cekChar = 'y') then
	begin
		cek := false;
		while(cek = false)do
		begin
			write('masukan id member tujuan : ');	readln(cekInt);
			cekb2 := findIdMember(cekInt);
			if(cekb2 = false) then
			begin
				writeln('member dengan id ',cekInt,' tidak ditemukan');
				writeln('silakan coba lagi');
			end
			else
			begin
				cek := true;
				newParkir.idMember := cekInt;
			end;
		end;
	end
	else if( cekChar ='n') then
	begin
		newParkir.isMember := false;
		cekInt := createNewNonMemberObject();
		newParkir.idMember := cekInt;
	end
	else
		writeln('inputan salah, coba lagi');
	inputNewParkir(newParkir);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure lihatMember(member : Member);
begin
	writeln('Data member;');
	writeln('nama member :',member.namaMember);
	writeln('ID member   :',member.idMember);
	writeln('ID RFID	 :',member.idRFID.idRFID);
	writeln();
	tahanBro();
end;

procedure lihatParkir(parkir : Parkir);
begin
	writeln('Data parkir');
	writeln('ID parkir        :',parkir.idParkir);
	writeln('ID member parkir :',parkir.idMember);
	writeln('plat nomor       :',parkir.platNomor);
	writeln('jam masuk        :',parkir.jamMasuk.jam,'-',parkir.jamMasuk.menit,'-',parkir.jamMasuk.detik);
	writeln('jamKeluar        :',parkir.jamKeluar.jam,'-',parkir.jamKeluar.menit,'-',parkir.jamKeluar.detik);
	writeln('biaya parkir     :',parkir.biaya);
	writeln();
	tahanBro();
end;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure lihatsedangParkir();
var
	i : integer;
begin
	if (counterNumParkir = 0 ) then
		writeln('belum ada pelanggan yang parkir')
	else
	begin
		for i:=0 to counterNumParkir do
		begin
			writeln('ID Parkir : ',masterProgram.parkir[i].idParkir);
			writeln('ID Member : ',masterProgram.parkir[i].idMember);
			writeln('Jam masuk : ',masterProgram.parkir[i].jamMasuk.jam,':',masterProgram.parkir[i].jamMasuk.menit,':',masterProgram.parkir[i].jamMasuk.detik);
			writeln('Jam keluar : ',masterProgram.parkir[i].jamKeluar.jam,':',masterProgram.parkir[i].jamKeluar.menit,':',masterProgram.parkir[i].jamKeluar.detik);
			writeln('Plat Nomor : ',masterProgram.parkir[i].platNomor);
			writeln('Biaya : ',masterProgram.parkir[i].biaya);
			writeln();
		end;
	end;
	clrscr();
end;

procedure lihatselesaiParkir();
var
	i : integer;
begin
	if (counterNumParkir = 0) then
		writeln('Belum ada pelanggan yang selesai parkir')
	else
		begin
			for i:=0 to counterNumTelahParkir do
			begin
			writeln('ID Parkir : ',masterProgram.telahParkir[i].idParkir);
			writeln('ID Member : ',masterProgram.telahParkir[i].idMember);
			writeln('Jam masuk : ',masterProgram.telahParkir[i].jamMasuk.jam,':',masterProgram.parkir[i].jamMasuk.menit,':',masterProgram.parkir[i].jamMasuk.detik);
			writeln('Jam keluar : ',masterProgram.telahParkir[i].jamKeluar.jam,':',masterProgram.parkir[i].jamKeluar.menit,':',masterProgram.parkir[i].jamKeluar.detik);
			writeln('Plat Nomor : ',masterProgram.telahParkir[i].platNomor);
			writeln('Biaya : ',masterProgram.telahParkir[i].biaya);
			writeln();
			end;
		end;
	clrscr();
end;


procedure bayarParkir();
var
	inpInt : integer;
	parkirs : Parkir;
	selesai,cek : boolean;
begin
	clrscr;
	writeln('--- bayar parkir ---');
	
	selesai := false;
	while(selesai = false) do
	begin
		writeln('masukan id member untuk member atau id struk untuk non member');
		write  ('id :'); readln(inpInt);
		parkirs := getPakirObject(inpInt);
		if(parkirs.idMember = 0) then
		begin
			writeln('id ',inpInt,' tidak terdaftar dalam sistem');
			writeln('silakan coba lagi');
		end
		else
		begin
			writeln('plat nomor : ',parkirs.platNomor);
			writeln('jam masuk  : ',parkirs.jamMasuk.jam,'-',parkirs.jamMasuk.menit,' ',parkirs.jamMasuk.detik);
			
			cek := false;
			while(cek = false)do
			begin
				writeln('masukan jam keluar ');
				write ('jam   : ' );	readln(parkirs.jamKeluar.jam);
				write ('menit : ' );	readln(parkirs.jamKeluar.menit);
				write ('detik : ' );	readln(parkirs.jamKeluar.detik);

				if((parkirs.jamKeluar.jam >= 0) and(parkirs.jamKeluar.jam <= 23) and (parkirs.jamKeluar.menit >= 0) and(parkirs.jamKeluar.menit <= 59) and (parkirs.jamKeluar.detik >= 0) and(parkirs.jamKeluar.detik <= 59)) then
				begin
					cek := true;
				end
				else
				begin
					writeln('inputan salah, silakan coba lagi');
				end;
			end;
		end;
		selesai := true;
	end;
	parkirs.biaya := hitungDurasiParkir(parkirs.jamMasuk,parkirs.jamKeluar);
	if(parkirs.isMember = true)then
		parkirs.biaya := parkirs.biaya * 1000
	else
		parkirs.biaya := parkirs.biaya * 1500;
	writeln('biaya : ',parkirs.biaya);
	writeln();
	writeln('tekan enter jika transaksi selesai');
	readln();
	inputNewTelahParkir(parkirs);
	writeln('proses pembayaran selesai');
	tahanBro();
end;

procedure menu();
var
	tempInt : integer;
	selesai : boolean;
begin
	selesai := false;
	startNewProgram();

	while(selesai = false) do
	begin
		clrscr;
		writeln('---------- Parkir Teknik Universitas World Class :v ----------');
		writeln('--  1.Registrasi Member baru                                --');
		writeln('--  2.Parkir                                                --');
		writeln('--  3.Bayar parkir                                          --');
		writeln('--  4.Lihat keadaan parkir                                  --');
		writeln('--  5.Lihat selesai parkir                                  --');
		writeln('--  6.keluar                                                --');
		writeln('--                                                          --');
		write  ('--  pilih : ');	readln(tempInt);
		if(tempInt = 1) then
			createNewMember()
		else if(tempInt = 2) then
			createNewParkir()
		else if(tempInt = 3) then
			bayarParkir()
		else if(tempInt = 4) then
			lihatsedangParkir()
		else if(tempInt = 5) then
			lihatselesaiParkir()
		else if(tempInt = 6) then
			selesai := true;
		readln();
	end;
	writeln();
	clrscr;
end;



begin
        menu();

        readln();
end.
