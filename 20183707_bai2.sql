--them, xoa, sua du lieu ( test)
insert into TINH(MATINH, TENTINH) 
VALUES ('HD', 'Hai Duong')

update tinh
set tentinh = 'Hung Yen'
where matinh = 'HD'

delete from TINH
where matinh = 'HD'

select * from tinh

alter table tinh 
add dientich float;

alter table tinh drop column dientich;
--bai tap thuc hanh
--a. Truy van co ban
--1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ’ 
select mact, hoten, vitri, ngaysinh, diachi,so
from CAUTHU
--2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ.
select *
from cauthu
where so = 7 and vitri = N'Tiền vệ';
--3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luận viên
select tenhlv, ngaysinh, diachi, dienthoai
from HUANLUANVIEN
--4. Hiển thị thông tin tất cả các cầu thủ có quốc tịch việt Nam thuộc câu lạc bộ Becamex Bình Dương
select ct.*
from cauthu ct, caulacbo clb, quocgia qg
where ct.maclb = clb.maclb and qg.maqg = ct.maqg and qg.tenqg = N'Việt Nam' and tenclb = N'Becamex Bình Dương'
--5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch “Bra-xin” 
select mact, hoten, ngaysinh, diachi, vitri
from cauthu ct, caulacbo clb, quocgia qg
where ct.maclb = clb.maclb and ct.maqg = qg.maqg and clb.tenclb = N'SHB Đà Nẵng' and tenqg = N'Bra-xin'
--6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An” 
select *
from cauthu ct, caulacbo clb, sanvd svd
where ct.maclb = clb.maclb and svd.masan = clb.masan and tensan =N'Long An'

--7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009
select b1.matran, b1.ngaytd, b1.tensan, b1.tenclb1, b2.tenclb2, b1.ketqua   
from  
((select td.matran, td.ngaytd, td.ketqua, clb.tenclb tenclb1, svd.tensan
from trandau td, caulacbo clb, sanvd svd
where td.maclb1 = clb.maclb and svd.masan = td.masan and td.vong = '2' and td.nam = '2009') b1
inner join 
(select  td.matran, clb.tenclb tenclb2
from trandau td, caulacbo clb, sanvd svd
where td.maclb2 = clb.maclb and svd.masan = td.masan and td.vong = '2' and td.nam = '2009') b2
on b1.matran = b2.matran)

--8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm veiecj của các huấn luyện viên có quốc tịch “ViệtNam”
select hlv.mahlv, hlv.tenhlv, hlv.ngaysinh, hlv.diachi , hlv_clb.vaitro, clb.tenclb
from caulacbo clb, huanluanvien hlv, quocgia qg, hlv_clb 
where  hlv.mahlv =hlv_clb.mahlv and clb.maclb = hlv_clb.maclb 
and hlv.maqg = qg.maqg  and qg.tenqg = N'Việt Nam';

--9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009  
select top(3) clb.tenclb
from caulacbo clb, bangxh bxh
where clb.maclb = bxh.maclb
order by bxh.diem desc

--10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương. 
select hlv.mahlv, hlv.tenhlv, hlv.ngaysinh, hlv.diachi, hlv_clb.vaitro, clb.tenclb
from caulacbo clb, tinh, hlv_clb,huanluanvien hlv
where tinh.matinh = clb.matinh and hlv_clb.maclb = clb.maclb and hlv_clb.mahlv = hlv.mahlv 
and tinh.tentinh = N'Bình Dương'

--b.  Các phép toán trên nhóm  
--1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ

select distinct clb.tenclb, count(ct.mact) soluongcauthu
from CAULACBO clb left join cauthu ct on clb.maclb = ct.maclb
group by clb.tenclb

--2. Thống kê số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) của mỗi câu lạc bộ
select  clb.tenclb, count(ct.mact) SL_cau_thu_nuoc_ngoai
from cauthu ct, quocgia qg,caulacbo clb
where ct.maqg = qg.maqg and clb.MACLB =ct.MACLB and qg.tenqg != N'Việt Nam'
group by clb.tenclb

--3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài. 
select clb.maclb, clb.tenclb,svd.tensan, ct.diachi 
from cauthu ct, quocgia qg,caulacbo clb,sanvd svd
where ct.maqg = qg.maqg and clb.MACLB =ct.MACLB and svd.masan = clb.masan and qg.tenqg != N'Việt Nam'
group by clb.tenclb,clb.maclb,svd.tensan,ct.diachi 
having count(mact) > 2

--4. Cho biết tên tỉnh, số lượng cầu thủ đang t hi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lí
select tinh.tentinh, count(mact) soluongct
from tinh, caulacbo clb, cauthu ct , sanvd svd
where tinh.matinh = clb.matinh and ct.maclb = clb.maclb  and svd.masan = clb.masan and ct.vitri = N'Tiền đạo' 
group by tinh.tentinh

--5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng vòng 3, năm 2009
select top(3) 
clb.tenclb, tinh.tentinh
from caulacbo clb, tinh, bangxh bxh
where clb.maclb = bxh.maclb and tinh.matinh = clb.matinh and bxh.vong = 3 and bxh.nam = 2009
order by bxh.hang desc 

--c. Các toán tử nâng cao  
--1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại
select hlv.tenhlv
from huanluanvien hlv, hlv_clb
where hlv.mahlv = hlv_clb.mahlv
group by hlv.tenhlv, hlv.mahlv
having count(hlv.DIENTHOAI) = 0

--2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào
select hlv.tenhlv 
from  huanluanvien hlv
where  not exists ( select *
				from hlv_clb
				where hlv_clb.mahlv = hlv.mahlv)

--3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3 
select ct.hoten
from cauthu ct, caulacbo clb, bangxh bxh
where ct.maclb = clb.maclb and bxh.maclb =clb.maclb and bxh.vong = 3 and bxh.nam = 2009
and (bxh.hang > 6 or bxh.hang < 3)

--4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 .
select b3.ngaytd, b3.tensan, b2.tenclb1, b3.tenclb2, b2.ketqua
from
((select td.ngaytd, svd.tensan, clb.tenclb tenclb1, td.ketqua, b1.tenclb tendoinhat
from trandau td,caulacbo clb, sanvd svd,(select top(1) bxh.maclb,clb.tenclb ,sum(bxh.diem) diem3vong
										 from bangxh bxh, caulacbo clb
										 where  clb.maclb = bxh.maclb and bxh.vong in (1,2,3) and bxh.nam = 2009
										 group by bxh.maclb, clb.tenclb
										 order by diem3vong desc) b1
where td.MACLB1 = clb.maclb and td.MASAN = svd.masan ) b2
inner join
(select td.ngaytd, svd.tensan, clb.tenclb tenclb2, td.ketqua, b1.tenclb tendoinhat
from trandau td,caulacbo clb, sanvd svd, (select top(1) bxh.maclb,clb.tenclb ,sum(bxh.diem) diem3vong
										 from bangxh bxh, caulacbo clb
										 where  clb.maclb = bxh.maclb and bxh.vong in (1,2,3) and bxh.nam = 2009
										 group by bxh.maclb, clb.tenclb
										 order by diem3vong desc)b1
where td.MACLB2 = clb.maclb and td.MASAN = svd.masan )  b3
on b2.NGAYTD = b3.ngaytd and b2.TENSAN = b3.tensan and b2.ketqua = b3.ketqua ) 
where  b3.tenclb2 = b3.tendoinhat or b2.tenclb1 = b2.tendoinhat
