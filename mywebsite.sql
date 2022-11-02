-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 02, 2022 lúc 12:01 PM
-- Phiên bản máy phục vụ: 10.4.24-MariaDB
-- Phiên bản PHP: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `mywebsite`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, 'Dress'),
(2, 'Skirt'),
(3, 'Pants'),
(4, 'Shirt'),
(5, 'Shorts');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doctrine_migration_versions`
--

CREATE TABLE `doctrine_migration_versions` (
  `version` varchar(191) COLLATE utf8_unicode_ci NOT NULL,
  `executed_at` datetime DEFAULT NULL,
  `execution_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `doctrine_migration_versions`
--

INSERT INTO `doctrine_migration_versions` (`version`, `executed_at`, `execution_time`) VALUES
('DoctrineMigrations\\Version20221022191037', '2022-10-22 21:10:47', 50),
('DoctrineMigrations\\Version20221022191642', '2022-10-22 21:24:26', 76),
('DoctrineMigrations\\Version20221022192731', '2022-10-22 21:27:39', 42),
('DoctrineMigrations\\Version20221022193022', '2022-10-22 21:30:28', 41),
('DoctrineMigrations\\Version20221022193646', '2022-10-22 21:36:55', 41),
('DoctrineMigrations\\Version20221022200303', '2022-10-22 22:03:37', 37),
('DoctrineMigrations\\Version20221022201155', '2022-10-22 22:12:24', 109),
('DoctrineMigrations\\Version20221022201650', '2022-10-22 22:17:16', 124),
('DoctrineMigrations\\Version20221022202205', '2022-10-22 22:24:25', 95);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `messenger_messages`
--

CREATE TABLE `messenger_messages` (
  `id` bigint(20) NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `headers` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue_name` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `available_at` datetime NOT NULL,
  `delivered_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order`
--

CREATE TABLE `order` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `shipment_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `total_price` double NOT NULL,
  `order_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order`
--

INSERT INTO `order` (`id`, `user_id`, `shipment_id`, `payment_id`, `total_price`, `order_date`) VALUES
(19, 3, 1, 1, 99.8, '2022-11-02'),
(20, 3, 1, 1, 221.3, '2022-11-02'),
(21, 3, 2, 1, 437.5, '2022-11-02'),
(22, 3, 4, 3, 233.2, '2022-11-02'),
(23, 3, 3, 1, 111.2, '2022-11-02'),
(24, 3, 3, 2, 288.8, '2022-11-02'),
(25, 3, 3, 4, 105.7, '2022-11-02'),
(26, 3, 2, 4, 125.2, '2022-11-02'),
(27, 3, 4, 2, 203, '2022-11-02'),
(28, 4, 1, 1, 136.4, '2022-11-02');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_detail`
--

CREATE TABLE `order_detail` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int(11) NOT NULL,
  `sub_total` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `order_detail`
--

INSERT INTO `order_detail` (`id`, `order_id`, `product_id`, `quantity`, `sub_total`) VALUES
(24, 19, 'SP7', 2, 65.6),
(25, 19, 'SP12', 1, 29.2),
(26, 20, 'SP14', 3, 107.1),
(27, 20, 'SP15', 3, 109.2),
(28, 21, 'SP13', 4, 208.8),
(29, 21, 'SP15', 3, 109.2),
(30, 21, 'SP9', 2, 81.4),
(31, 21, 'SP3', 1, 34.6),
(32, 22, 'SP13', 3, 156.6),
(33, 22, 'SP15', 2, 72.8),
(34, 23, 'SP8', 1, 34.2),
(35, 23, 'SP15', 2, 72.8),
(36, 24, 'SP2', 5, 250),
(37, 24, 'SP3', 1, 34.6),
(38, 25, 'SP9', 2, 81.4),
(39, 25, 'SP10', 1, 20.1),
(40, 26, 'SP5', 2, 86),
(41, 26, 'SP14', 1, 35.7),
(42, 27, 'SP4', 4, 199.2),
(43, 28, 'SP1', 1, 50),
(44, 28, 'SP9', 2, 81.4);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `payment`
--

CREATE TABLE `payment` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `payment`
--

INSERT INTO `payment` (`id`, `name`) VALUES
(1, 'Visa'),
(2, 'MasterCard'),
(3, 'PayPal'),
(4, 'MoMo');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product`
--

CREATE TABLE `product` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double NOT NULL,
  `quantity` int(11) NOT NULL,
  `import_date` date NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `product`
--

INSERT INTO `product` (`id`, `category_id`, `name`, `price`, `quantity`, `import_date`, `description`, `image`) VALUES
('SP1', 1, 'Pleated Gold Dress', 50, 50, '2022-01-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP1.jpg'),
('SP10', 5, 'Yellow Brown Shorts', 20.1, 50, '2022-03-11', 'High-quality Tuytsy material combined with brown color brings elegance and youthfulness to the wearer. Design can be combined with T-shirts, shirts. Shorts are suitable for walking with friends and family.', 'SP10.jpg'),
('SP12', 5, 'White Shorts With Rib Pocket', 29.2, 50, '2022-03-20', 'Design white shorts with rib pocket, highlighting the wearer\'s legs, creating a height increase effect. With the high-quality selected Tuytsi material, the shorts in white are minimalistic but attractive. Shorts bring comfort and charisma to the wearer.', 'SP12.jpg'),
('SP13', 1, 'Waist Belted White Dress', 52.2, 50, '2022-03-20', 'Designed with a trendy and luxurious white brocade dress, elegant and minimalist, with high-quality brocade material, the dress brings a sense of confidence to the wearer. Dress can be combined with sandals, high heels and accompanying accessories.', 'SP13.jpg'),
('SP14', 4, 'Light Yellow Vest', 35.7, 50, '2022-03-28', 'The design of the light yellow vest is luxurious, minimalist but delicate, trendy. With the high-quality selected Tuytsi material, the shirt is further accentuated by logo buttons and unique cutouts. Design can be combined with pants, baggy and skirt.', 'SP14.jpg'),
('SP15', 4, 'Silk Pink Vest', 36.4, 50, '2022-03-28', 'The design of pink silk vest is luxurious, minimalist but trendy. With high-quality selected silk, the shirt is further accentuated with a flower attached to the chest to bring confidence and attractiveness to the wearer. Design can be combined with skirt', 'SP15.jpg'),
('SP16', 1, 'Vest Neck Black Dress', 42.5, 50, '2022-04-15', 'Designed with high-class antique flower-embroidered black dress with selected Tuytsi material, luxurious and noble stylized neckline. Sexy black color, waist part conceals body defects. Dress can be combined with high heels and accompanying accessories.', 'SP16.jpg'),
('SP2', 1, 'Beaded Plum Red Dress', 50, 50, '2022-01-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP2.jpg'),
('SP3', 2, 'Plaid White Skirt', 34.6, 50, '2022-01-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP3.jpg'),
('SP4', 1, 'Pleated Black Silk Dress', 49.8, 50, '2022-01-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP4.jpg'),
('SP5', 1, 'White Chiffon Dress With Lace Sleeves', 43, 50, '2022-01-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP5.jpg'),
('SP6', 3, 'Beige Brown Pants', 35.1, 50, '2022-03-08', 'Pleated design with luxurious textures, elegant spreading shape, easy to coordinate with any accessories. The color is elegant, the product brings a sense of comfort and confidence to the wearer. The product can be combined with high heels, sandals.', 'SP6.jpg'),
('SP7', 5, 'Green Silk Shorts', 32.8, 50, '2022-03-08', 'The design of the shorts accentuates the wearer\'s legs, creating a height-enhancing effect. Shorts bring comfort and attractiveness to the wearer. The pants are suitable for hanging out with friends. Design can be combined with shirts, t-shirts.', 'SP7.jpg'),
('SP8', 2, 'Orange Chiffon Skirt', 34.2, 50, '2022-03-10', 'Elegant and trendy orange silk skirt design. On the background of high-quality selected silk, the product brings comfort to the wearer. Products can be combined with shirts, t-shirts and accompanying accessories.', 'SP8.jpg'),
('SP9', 2, 'Blue Floral Chiffon Skirt', 40.7, 50, '2022-03-10', 'Elegant and trendy blue floral silk skirt design. On the background of high-quality selected silk, the product brings comfort to the wearer. Products can be combined with shirts, t-shirts and accompanying accessories.', 'SP9.jpg');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `shipment`
--

CREATE TABLE `shipment` (
  `id` int(11) NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `shipment`
--

INSERT INTO `shipment` (`id`, `name`, `price`) VALUES
(1, 'Giaohangnhanh', 5),
(2, 'VNPost', 3.5),
(3, 'Viettel Post', 4.2),
(4, 'AhaMove', 3.8);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `email` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roles` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(DC2Type:json)',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `user`
--

INSERT INTO `user` (`id`, `email`, `roles`, `password`, `full_name`, `phone_number`, `address`) VALUES
(1, 'phyo@fpt.edu.vn', '[\"ROLE_MANAGER\"]', '$2y$13$./CQG0YRplUvs4lxoiVBmu3Wav8JEw39xSDoYhn6Rhyv6v5kCWKym', 'Phyo Min Tun', '0905777555', '57 Tran Nhan Tong, Da Nang'),
(2, 'trandieuthao@gmail.com', '[\"ROLE_ADMIN\"]', '$2y$13$6lgvpMTX55Aoj3jyS9lMsezwMnKfAocpQoJJayit2ysPzI.lE7IJ6', 'Tran Dieu Thao', '0905441333', '30 Tran Cao Van, Da Nang'),
(3, 'dotheson@gmail.com', '[]', '$2y$13$UpeX1kEgVcID4EogdvMLZeTllh7R1mwyujN8R3qZIaAlVX.WW2rF.', 'Do The Son', '077485584', '148 Ham Nghi, Da Nang'),
(4, 'hieunguyen@gmail.com', '[]', '$2y$13$/H03NkF2kcaQ3zOrBEApHuOis4UvWhVJEcluaJAe0yUwv53/SZoAO', 'Nguyen Cong Hieu', '0905111222', '45 Nguyen Van Linh, Da Nang');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_BA388B7A76ED395` (`user_id`),
  ADD KEY `IDX_BA388B74584665A` (`product_id`);

--
-- Chỉ mục cho bảng `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `doctrine_migration_versions`
--
ALTER TABLE `doctrine_migration_versions`
  ADD PRIMARY KEY (`version`);

--
-- Chỉ mục cho bảng `messenger_messages`
--
ALTER TABLE `messenger_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_75EA56E0FB7336F0` (`queue_name`),
  ADD KEY `IDX_75EA56E0E3BD61CE` (`available_at`),
  ADD KEY `IDX_75EA56E016BA31DB` (`delivered_at`);

--
-- Chỉ mục cho bảng `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_F5299398A76ED395` (`user_id`),
  ADD KEY `IDX_F52993987BE036FC` (`shipment_id`),
  ADD KEY `IDX_F52993984C3A3BB` (`payment_id`);

--
-- Chỉ mục cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_ED896F46FCDAEAAA` (`order_id`),
  ADD KEY `IDX_ED896F464584665A` (`product_id`);

--
-- Chỉ mục cho bảng `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `IDX_D34A04AD12469DE2` (`category_id`);

--
-- Chỉ mục cho bảng `shipment`
--
ALTER TABLE `shipment`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT cho bảng `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `messenger_messages`
--
ALTER TABLE `messenger_messages`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `order`
--
ALTER TABLE `order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT cho bảng `payment`
--
ALTER TABLE `payment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `shipment`
--
ALTER TABLE `shipment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `FK_BA388B74584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_BA388B7A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Các ràng buộc cho bảng `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `FK_F52993984C3A3BB` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`),
  ADD CONSTRAINT `FK_F52993987BE036FC` FOREIGN KEY (`shipment_id`) REFERENCES `shipment` (`id`),
  ADD CONSTRAINT `FK_F5299398A76ED395` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

--
-- Các ràng buộc cho bảng `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `FK_ED896F464584665A` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `FK_ED896F46FCDAEAAA` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`);

--
-- Các ràng buộc cho bảng `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `FK_D34A04AD12469DE2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
