require 'set'

P = Struct.new(:x, :y) do
  def left; P.new(x - 1, y); end
  def right; P.new(x + 1, y); end
  def down; P.new(x, y + 1); end
  def up; P.new(x, y - 1); end
  def dup; P.new(x, y); end
end

input = DATA.read
DEBUG = false
TOP = 250

max_y = 0
max_x = 0
min_x = Float::INFINITY
min_y = Float::INFINITY
spring = P.new(500, 0)
tails = [spring.down]
falls = tails.to_set
clay = {}
water = { spring.down => true }

input.each_line do |line|
  break if line.start_with? '---'
  single, range = line.split(', ')
  if single.start_with?('y')
    y = single[2..-1].to_i
    min_y = y if y < min_y
    max_y = y if y > max_y
    x_start, x_end = range[2..-1].split('..').map(&:to_i)
    (x_start..x_end).each do |x|
      min_x = x if x < min_x
      max_x = x if x > max_x
      clay[P.new(x, y)] = true
    end
  else
    x = single[2..-1].to_i
    min_x = x if x < min_x
    max_x = x if x > max_x
    y_start, y_end = range[2..-1].split('..').map(&:to_i)
    (y_start..y_end).each do |y|
      min_y = y if y < min_y
      max_y = y if y > max_y
      clay[P.new(x, y)] = true
    end
  end
end

# max_y = TOP
min_x -= 3
max_x += 3

def print_board(water, clay, min_x, max_x, max_y)
  board = []
  (0..max_y + 2).each do |y|
    (min_x..max_x).each do |x|
      p = P.new(x, y)
      x -= min_x
      board[y] ||= []
      if clay[p]
        board[y][x] = '#'
      elsif water[p]
        board[y][x] = '~'
      else
        board[y][x] = '.'
      end
    end
  end
  puts "\n"
  puts board.map(&:join)
end

until tails.empty?
  tail = tails.pop
  next if tail.y >= max_y
  water[tail] = true

  if clay[tail.down]
    left = right = row_seed = tail.dup
    left_contained = right_contained = true

    loop do
      loop do
        if !clay[left.down] && !water[left.down]
          tails << left if !tails.include?(left) && !falls.include?(left.right)
          falls << left
          left_contained = false
          break
        end

        water[left] = true
        break if clay[left.left]
        left = left.left
      end

      loop do
        if !clay[right.down] && !water[right.down]
          tails << right if !tails.include?(right) && !falls.include?(right.left)
          falls << right
          right_contained = false
          break
        end

        water[right] = true
        break if clay[right.right]
        right = right.right
      end

      break if !left_contained || !right_contained

      row_seed = row_seed.up
      left = right = row_seed.dup
    end
  else
    water[tail.down] = true
    tails << tail.down
  end
end

print_board(water, clay, min_x, max_x, max_y) if DEBUG

puts water.keys.size - min_y + 1

__END__
y=662, x=546..550
y=250, x=525..527
x=476, y=212..215
x=543, y=633..642
x=589, y=509..537
y=1397, x=476..495
x=398, y=1869..1882
x=408, y=1822..1836
x=444, y=118..127
x=616, y=624..637
y=1583, x=536..547
y=1178, x=405..407
y=674, x=588..590
x=523, y=1475..1485
y=634, x=606..610
y=621, x=597..610
x=646, y=1454..1455
x=550, y=701..703
y=819, x=590..592
x=586, y=449..462
x=404, y=1088..1102
y=1843, x=539..541
y=1331, x=524..534
y=921, x=405..411
y=1367, x=497..514
y=415, x=530..535
y=40, x=645..648
x=467, y=134..143
x=455, y=483..487
y=1499, x=474..498
x=607, y=842..844
x=642, y=1419..1424
x=588, y=1339..1346
y=720, x=441..466
x=385, y=1031..1044
x=442, y=1121..1135
y=868, x=590..607
y=1320, x=646..648
x=524, y=1671..1695
x=531, y=392..397
y=1360, x=662..667
x=421, y=1294..1303
y=57, x=538..556
x=454, y=949..959
x=548, y=1834..1846
x=612, y=897..909
y=580, x=598..620
x=386, y=1084..1089
y=1251, x=496..511
x=495, y=833..841
x=574, y=1222..1227
x=537, y=1100..1108
y=54, x=612..616
x=423, y=1511..1526
x=569, y=796..803
x=468, y=328..350
y=312, x=432..436
x=469, y=524..537
x=612, y=1707..1710
x=460, y=713..717
x=506, y=1397..1407
x=515, y=933..934
x=577, y=669..678
x=649, y=1341..1360
x=458, y=760..765
x=542, y=333..335
y=1285, x=538..540
x=587, y=1549..1570
x=604, y=1524..1530
x=418, y=1295..1303
y=1799, x=582..590
x=476, y=466..478
x=543, y=1062..1065
y=18, x=508..510
x=443, y=420..428
y=844, x=605..607
x=470, y=1139..1153
y=869, x=536..543
y=1044, x=385..404
y=1156, x=389..417
x=532, y=812..815
x=436, y=1593..1607
x=518, y=730..733
x=522, y=366..379
y=685, x=556..559
x=616, y=1658..1670
x=645, y=240..252
x=387, y=337..353
x=473, y=1762..1780
x=438, y=119..127
y=1312, x=551..572
y=1607, x=420..436
x=536, y=1983..1994
x=630, y=813..816
x=622, y=1900..1905
x=389, y=631..651
y=1573, x=479..483
x=594, y=1310..1312
y=1530, x=599..604
x=634, y=602..604
x=438, y=529..531
x=609, y=667..674
y=1513, x=591..612
x=463, y=1140..1153
x=430, y=115..129
y=1446, x=523..541
x=575, y=1048..1058
y=420, x=461..488
y=265, x=485..511
y=1112, x=493..511
y=1801, x=483..493
x=575, y=1070..1083
x=600, y=668..678
x=542, y=698..708
x=421, y=1888..1895
x=487, y=400..404
x=664, y=1261..1263
x=668, y=1214..1219
y=989, x=620..623
y=1653, x=473..493
y=459, x=469..493
y=500, x=591..610
x=649, y=768..779
x=598, y=1078..1080
y=462, x=558..586
x=670, y=1173..1187
x=643, y=1131..1145
x=539, y=1378..1385
x=598, y=553..580
y=1142, x=523..527
x=458, y=1124..1133
x=628, y=1387..1403
x=529, y=1223..1231
x=419, y=720..726
y=147, x=574..587
x=571, y=322..336
y=869, x=389..402
x=606, y=630..634
x=422, y=661..687
y=1795, x=537..558
y=1275, x=562..570
x=495, y=1385..1397
y=1104, x=566..624
x=547, y=1577..1583
x=584, y=832..842
x=563, y=1612..1639
x=436, y=294..312
y=1291, x=483..507
x=535, y=200..213
x=572, y=1637..1645
x=587, y=145..147
y=392, x=516..531
x=466, y=761..765
y=404, x=474..487
x=604, y=521..523
x=488, y=793..798
x=572, y=1820..1832
x=626, y=1662..1667
x=509, y=78..80
y=1832, x=570..572
x=627, y=603..604
y=104, x=589..601
x=624, y=771..787
x=584, y=735..747
x=459, y=968..970
x=522, y=1276..1293
x=607, y=1360..1362
x=485, y=1058..1067
x=470, y=849..853
y=717, x=457..460
x=543, y=846..869
x=469, y=627..633
x=583, y=548..562
x=494, y=1286..1288
x=480, y=508..517
y=651, x=389..412
y=473, x=485..488
x=536, y=350..361
x=522, y=263..277
x=478, y=1025..1033
x=646, y=1306..1320
x=436, y=87..102
x=482, y=427..439
x=567, y=549..562
x=448, y=665..678
x=496, y=36..39
x=417, y=1153..1156
x=520, y=1747..1757
x=601, y=78..104
x=446, y=1745..1757
x=391, y=671..695
y=926, x=492..499
x=494, y=763..770
y=1370, x=433..440
x=658, y=994..1008
y=1672, x=426..432
x=644, y=383..393
x=476, y=1259..1270
x=487, y=957..965
x=503, y=690..716
x=553, y=130..155
x=520, y=1682..1696
x=504, y=1996..1997
y=1331, x=502..521
y=1096, x=423..428
x=394, y=789..812
y=173, x=600..626
x=549, y=1525..1527
x=499, y=665..679
x=518, y=306..319
x=604, y=1937..1959
y=687, x=429..431
x=439, y=1337..1353
y=595, x=482..501
x=554, y=589..601
y=167, x=637..656
x=445, y=1068..1076
x=592, y=757..770
y=1351, x=414..424
x=596, y=1823..1837
x=500, y=820..825
x=419, y=1276..1285
x=471, y=1599..1609
x=404, y=157..183
x=629, y=1702..1710
y=715, x=507..513
y=1842, x=386..395
y=1760, x=432..452
y=1633, x=484..508
x=519, y=199..213
x=639, y=901..920
x=562, y=698..708
x=590, y=1797..1799
y=1108, x=519..537
y=1363, x=529..551
x=471, y=968..970
y=80, x=509..514
y=336, x=571..592
x=452, y=396..406
x=523, y=409..420
y=1577, x=470..472
y=1710, x=629..637
x=426, y=1651..1672
x=485, y=315..323
x=539, y=1598..1605
y=1209, x=503..528
x=539, y=209..217
y=596, x=418..445
x=583, y=1051..1062
y=1851, x=646..664
x=617, y=934..948
y=1480, x=533..535
y=113, x=540..546
x=468, y=864..885
x=591, y=490..500
y=188, x=515..533
x=479, y=1570..1573
x=380, y=1084..1089
x=554, y=701..703
x=536, y=1599..1605
x=466, y=363..374
x=655, y=1272..1275
x=613, y=835..848
x=455, y=87..102
x=527, y=1004..1006
x=437, y=64..76
y=1006, x=527..536
x=596, y=518..529
x=390, y=1452..1460
x=393, y=944..947
y=1748, x=602..626
x=507, y=1767..1781
y=885, x=468..486
x=509, y=776..778
y=1826, x=424..546
x=509, y=617..620
x=668, y=1550..1553
x=566, y=1093..1104
y=1868, x=571..579
x=429, y=663..687
x=589, y=77..104
y=1238, x=527..546
x=514, y=1375..1388
y=1272, x=440..463
x=605, y=666..674
x=493, y=1643..1653
x=497, y=768..781
y=970, x=459..471
x=498, y=1706..1718
y=947, x=393..398
y=1751, x=564..581
x=402, y=231..256
x=663, y=650..661
x=578, y=54..65
x=457, y=1537..1552
x=511, y=932..934
y=1884, x=597..599
y=661, x=643..663
x=391, y=1721..1729
x=510, y=116..129
x=535, y=224..236
y=1231, x=511..529
x=448, y=114..123
x=432, y=1493..1504
x=650, y=842..855
y=983, x=464..477
x=442, y=1067..1076
x=432, y=1236..1240
x=548, y=221..231
y=220, x=581..584
x=575, y=90..97
y=256, x=402..413
x=457, y=340..342
x=612, y=878..883
x=607, y=1666..1681
x=603, y=303..318
x=573, y=567..576
x=650, y=1508..1523
x=655, y=1820..1835
y=1681, x=607..609
x=556, y=653..666
y=1591, x=485..505
y=1695, x=524..529
x=444, y=1225..1250
x=549, y=630..639
x=634, y=850..856
y=679, x=499..511
x=612, y=1504..1513
y=1135, x=605..627
x=513, y=139..141
x=392, y=433..438
y=1499, x=557..566
x=483, y=1780..1801
x=651, y=130..137
x=508, y=32..42
x=531, y=1725..1738
x=546, y=1982..1994
y=671, x=616..635
x=528, y=1197..1209
y=1924, x=539..565
x=441, y=1745..1757
x=567, y=91..97
x=409, y=987..990
x=454, y=1189..1212
y=1286, x=494..498
y=1716, x=520..538
x=441, y=693..720
x=622, y=728..754
x=544, y=179..191
y=1931, x=401..573
x=404, y=1030..1044
x=523, y=1341..1345
y=1148, x=515..533
y=765, x=458..466
y=841, x=495..506
y=444, x=600..616
x=655, y=31..46
x=569, y=991..1019
x=502, y=880..901
x=407, y=1175..1178
y=514, x=486..490
y=1020, x=593..639
x=568, y=411..413
y=1102, x=396..404
x=554, y=223..236
x=497, y=1600..1609
x=398, y=460..487
x=668, y=1976..1983
x=409, y=1617..1643
x=542, y=1131..1145
x=409, y=212..220
x=427, y=1543..1560
y=1046, x=640..646
y=413, x=530..535
x=424, y=1814..1826
y=354, x=430..436
x=643, y=649..661
x=544, y=1878..1890
x=536, y=792..804
y=390, x=664..668
x=654, y=86..90
x=450, y=1226..1250
x=459, y=1660..1671
x=533, y=177..188
x=646, y=1846..1851
y=1142, x=605..627
x=391, y=1797..1800
x=614, y=1280..1284
x=578, y=941..952
x=628, y=802..804
x=547, y=1377..1385
x=530, y=972..982
x=449, y=92..96
y=862, x=597..601
x=550, y=891..900
x=399, y=711..731
x=647, y=130..137
x=575, y=1425..1449
x=596, y=1636..1645
x=532, y=1835..1846
y=1671, x=459..505
x=501, y=1169..1175
x=529, y=197..210
y=654, x=565..591
x=432, y=529..531
x=511, y=1241..1251
y=84, x=502..523
x=430, y=348..354
x=431, y=1120..1135
x=431, y=662..687
x=623, y=989..992
x=426, y=1051..1078
y=21, x=499..516
y=687, x=422..424
y=856, x=620..634
x=510, y=9..18
y=1738, x=434..531
y=799, x=522..533
x=525, y=890..900
x=577, y=567..576
y=1895, x=395..421
y=117, x=473..489
y=1893, x=535..552
x=410, y=302..320
x=398, y=1675..1691
x=542, y=1475..1485
y=733, x=499..518
x=658, y=1619..1633
x=665, y=957..962
x=389, y=461..487
y=513, x=443..450
y=529, x=432..438
x=656, y=86..90
x=620, y=989..992
x=664, y=364..390
x=505, y=1563..1573
x=578, y=327..330
y=1145, x=542..643
x=421, y=239..250
x=576, y=926..928
x=633, y=1948..1972
y=1196, x=463..486
x=460, y=396..406
y=267, x=414..442
y=319, x=518..537
x=550, y=1858..1870
x=428, y=961..966
y=1552, x=457..471
x=392, y=894..910
y=1080, x=595..598
x=424, y=660..687
y=466, x=448..452
y=793, x=486..488
y=278, x=650..660
y=379, x=505..522
y=129, x=415..430
x=642, y=1753..1778
y=1474, x=623..637
x=613, y=518..529
x=505, y=345..358
y=139, x=472..476
x=578, y=965..968
y=1707, x=610..612
y=1380, x=425..446
x=426, y=1512..1526
y=318, x=594..603
x=559, y=683..685
y=490, x=620..639
x=587, y=154..159
x=506, y=1539..1549
x=532, y=652..666
y=1800, x=388..391
y=1983, x=589..616
x=472, y=1556..1577
x=511, y=250..265
x=411, y=700..709
x=520, y=1706..1716
x=543, y=129..155
x=564, y=183..189
x=552, y=1455..1468
y=886, x=604..622
x=433, y=918..923
x=586, y=1267..1277
x=561, y=1939..1952
y=1780, x=468..473
x=440, y=1370..1374
y=693, x=530..533
y=216, x=498..500
y=1713, x=525..531
x=460, y=327..350
x=482, y=133..143
x=496, y=1260..1270
x=605, y=1386..1389
x=540, y=105..113
y=1288, x=538..540
y=1546, x=558..567
y=618, x=637..641
y=1482, x=533..535
y=537, x=469..567
x=557, y=1484..1499
x=460, y=737..741
x=524, y=1316..1331
x=637, y=152..167
x=509, y=1866..1885
x=502, y=36..39
y=1036, x=468..484
y=144, x=597..610
y=1573, x=487..505
y=1526, x=423..426
x=586, y=780..791
x=482, y=161..167
x=641, y=613..618
x=593, y=720..744
x=588, y=672..674
x=563, y=734..747
x=415, y=460..486
y=1781, x=507..531
y=350, x=460..468
y=1670, x=616..634
x=424, y=1003..1005
y=1923, x=385..394
x=443, y=903..925
x=420, y=492..504
x=385, y=1920..1923
x=564, y=196..223
y=36, x=496..502
y=1044, x=656..658
y=1248, x=617..632
x=616, y=1015..1017
y=1764, x=390..396
x=492, y=1176..1181
x=610, y=1454..1476
x=551, y=1358..1363
x=480, y=1058..1067
x=593, y=1007..1020
x=525, y=1790..1799
x=544, y=792..804
x=643, y=768..779
y=78, x=509..514
x=631, y=565..574
x=618, y=1699..1716
y=1797, x=388..391
x=510, y=139..141
x=590, y=857..868
y=57, x=603..622
y=785, x=423..429
y=1993, x=611..635
y=731, x=384..399
x=468, y=1012..1036
y=290, x=463..473
x=429, y=1841..1867
x=597, y=854..862
y=1048, x=650..666
x=492, y=52..64
y=1428, x=594..610
x=574, y=1961..1974
x=533, y=1457..1466
x=644, y=226..232
x=608, y=985..995
x=590, y=672..674
x=462, y=1611..1629
y=98, x=482..493
x=564, y=1725..1751
x=499, y=1298..1311
x=430, y=1237..1240
x=655, y=1753..1778
x=503, y=1940..1941
x=380, y=1778..1803
y=1219, x=643..668
x=564, y=911..938
x=507, y=859..867
x=540, y=1285..1288
x=525, y=1703..1713
x=498, y=1497..1499
x=447, y=479..491
x=538, y=973..982
x=637, y=772..787
x=519, y=114..126
x=472, y=501..502
x=441, y=421..428
x=450, y=1772..1786
y=910, x=392..416
x=636, y=319..344
x=504, y=1354..1364
x=476, y=136..139
x=406, y=900..905
x=570, y=21..38
y=1460, x=390..417
x=663, y=1534..1538
y=928, x=576..578
x=537, y=305..319
x=389, y=863..869
x=579, y=1863..1868
x=552, y=1553..1555
x=562, y=1264..1275
y=1370, x=406..409
x=636, y=227..232
x=602, y=902..904
x=462, y=61..64
y=962, x=644..665
x=394, y=1170..1181
x=515, y=589..608
y=1133, x=458..468
y=1437, x=440..467
y=770, x=575..592
x=466, y=692..720
x=544, y=221..231
y=273, x=536..538
x=576, y=54..65
x=539, y=1924..1927
x=516, y=1174..1187
y=1277, x=586..597
x=535, y=811..815
x=445, y=1832..1852
x=531, y=502..518
x=448, y=1493..1504
x=495, y=487..497
y=1867, x=429..438
y=464, x=645..661
x=476, y=1025..1033
y=965, x=487..511
x=627, y=1135..1142
x=561, y=1249..1251
y=926, x=576..578
y=145, x=642..661
x=531, y=617..620
x=477, y=598..600
y=1602, x=485..490
y=97, x=567..575
y=402, x=605..630
x=640, y=1033..1046
y=720, x=419..426
x=591, y=1401..1410
x=511, y=958..965
y=674, x=605..609
x=468, y=1124..1133
x=404, y=771..778
x=513, y=559..568
y=1263, x=383..394
x=590, y=275..287
x=537, y=484..489
x=493, y=447..459
x=591, y=1937..1959
x=572, y=796..803
x=550, y=656..662
x=659, y=1248..1252
y=1604, x=485..490
y=900, x=397..406
x=538, y=1285..1288
x=530, y=673..693
x=529, y=1430..1443
y=1374, x=433..440
x=412, y=1230..1244
y=794, x=657..659
x=485, y=1257..1267
x=597, y=1884..1887
x=454, y=1061..1076
x=428, y=157..183
y=207, x=581..584
y=1983, x=664..668
y=1005, x=424..428
x=617, y=282..294
x=434, y=1451..1473
x=556, y=326..338
x=551, y=178..191
y=105, x=512..534
y=1756, x=544..561
x=536, y=271..273
x=485, y=1602..1604
x=625, y=1515..1542
x=535, y=895..897
x=452, y=49..54
y=1391, x=431..444
y=1468, x=549..552
x=486, y=793..798
y=995, x=608..629
x=626, y=1342..1360
x=474, y=401..404
y=864, x=551..573
x=655, y=1629..1631
x=438, y=1285..1301
x=556, y=683..685
y=1974, x=387..574
x=581, y=1881..1891
x=584, y=919..931
x=514, y=1339..1348
x=599, y=361..365
x=563, y=84..97
x=614, y=685..690
x=625, y=727..754
x=571, y=892..908
x=591, y=1504..1513
y=397, x=516..531
y=604, x=627..634
y=601, x=554..577
x=506, y=833..841
y=344, x=628..636
x=438, y=956..969
y=1041, x=393..398
x=463, y=76..81
x=573, y=813..825
y=413, x=566..568
x=484, y=1620..1633
x=442, y=65..76
x=570, y=1819..1832
x=527, y=117..129
x=419, y=1938..1942
x=557, y=892..908
y=1212, x=442..454
x=525, y=242..250
y=1424, x=619..642
x=482, y=915..924
y=1149, x=654..662
x=504, y=995..1005
y=877, x=473..477
y=948, x=589..593
x=575, y=1309..1312
y=1476, x=610..618
x=608, y=4..6
y=855, x=637..650
x=616, y=51..54
x=387, y=1393..1401
x=447, y=1529..1530
x=609, y=1070..1083
x=565, y=1924..1927
y=338, x=505..556
x=520, y=286..297
x=470, y=1557..1577
x=483, y=1866..1882
x=556, y=264..275
x=450, y=171..175
y=144, x=446..457
x=396, y=111..120
x=642, y=78..97
x=546, y=1236..1238
y=1443, x=529..533
x=639, y=1565..1571
x=585, y=1203..1229
x=516, y=1792..1804
y=1643, x=399..409
y=574, x=628..631
x=414, y=1343..1351
y=1718, x=494..498
x=473, y=112..117
y=167, x=464..482
x=610, y=1707..1710
x=522, y=501..518
x=395, y=1820..1842
x=476, y=1368..1381
y=642, x=543..560
x=409, y=1364..1370
y=1240, x=430..432
y=966, x=428..432
x=534, y=1315..1331
x=611, y=1988..1993
x=483, y=1570..1573
x=527, y=1237..1238
y=487, x=455..458
x=530, y=284..292
x=450, y=903..925
x=637, y=1468..1474
y=1688, x=563..569
x=489, y=111..117
x=458, y=1041..1046
x=472, y=136..139
x=498, y=881..901
x=616, y=66..73
y=236, x=535..554
x=551, y=1309..1312
y=489, x=537..540
y=1426, x=539..553
y=494, x=503..506
x=643, y=262..274
y=1552, x=496..512
y=96, x=447..449
x=455, y=50..54
x=434, y=18..44
x=599, y=813..825
x=566, y=1485..1499
x=502, y=1995..1997
x=614, y=721..744
x=414, y=1170..1181
y=137, x=647..651
y=542, x=426..448
x=571, y=1862..1868
y=275, x=556..558
x=512, y=1541..1552
y=1252, x=637..659
x=426, y=523..542
x=487, y=31..42
x=396, y=983..995
x=484, y=1367..1381
x=511, y=1092..1112
x=527, y=303..315
y=1172, x=437..459
y=1609, x=606..631
y=582, x=565..583
x=420, y=1593..1607
x=438, y=170..175
x=513, y=229..240
y=825, x=500..503
x=606, y=209..231
x=502, y=1319..1331
y=608, x=515..518
y=781, x=497..518
x=642, y=119..145
x=452, y=500..502
x=545, y=610..621
y=1349, x=446..448
x=452, y=627..633
x=432, y=294..312
y=1696, x=449..520
x=516, y=1412..1421
y=633, x=452..469
x=558, y=1770..1795
x=394, y=1721..1729
x=521, y=1790..1799
x=540, y=484..489
y=417, x=561..576
x=495, y=467..478
y=901, x=498..502
x=399, y=1392..1401
x=500, y=212..216
y=1267, x=485..487
y=292, x=530..532
x=437, y=1150..1172
x=414, y=714..733
x=553, y=1418..1426
x=666, y=1028..1048
y=1699, x=586..592
x=411, y=1120..1137
x=487, y=1257..1267
y=990, x=409..416
x=514, y=363..371
x=585, y=646..650
x=498, y=229..240
x=394, y=1242..1263
y=741, x=448..460
x=464, y=161..167
x=542, y=410..420
x=519, y=1299..1311
y=126, x=519..521
x=499, y=11..21
x=551, y=1596..1602
x=623, y=1279..1307
y=968, x=578..580
y=1570, x=587..612
x=601, y=854..862
x=409, y=1419..1429
x=499, y=1623..1628
x=400, y=1524..1541
y=695, x=389..391
y=1852, x=445..451
y=1846, x=532..548
x=589, y=1980..1983
y=183, x=650..656
x=396, y=1087..1102
x=476, y=1385..1397
x=567, y=1524..1546
y=393, x=644..647
x=575, y=758..770
y=1455, x=646..662
x=534, y=1627..1652
x=486, y=154..166
x=661, y=400..419
x=394, y=1919..1923
x=436, y=374..376
y=568, x=513..528
y=1410, x=591..619
x=436, y=558..580
x=516, y=893..912
x=477, y=870..877
x=493, y=1779..1801
x=443, y=1605..1611
x=556, y=55..57
y=1837, x=596..598
x=459, y=1322..1329
y=1605, x=536..539
x=546, y=1814..1826
x=398, y=944..947
x=425, y=1360..1380
x=543, y=1024..1041
x=664, y=1845..1851
x=457, y=305..331
x=380, y=581..609
y=895, x=654..662
x=497, y=1356..1367
x=634, y=1529..1534
x=502, y=72..84
y=497, x=495..512
x=665, y=343..352
y=747, x=563..584
y=1786, x=435..450
x=590, y=125..130
y=621, x=545..588
y=1885, x=509..521
x=464, y=1610..1629
x=570, y=1265..1275
x=423, y=955..969
x=499, y=343..354
x=448, y=1345..1349
y=529, x=596..613
y=1243, x=623..625
x=664, y=516..539
x=458, y=1061..1076
x=605, y=1135..1142
y=400, x=493..568
y=923, x=424..433
x=438, y=508..519
y=716, x=475..503
y=1530, x=447..461
x=499, y=49..59
x=475, y=690..716
x=521, y=1866..1885
x=631, y=1595..1609
x=506, y=1170..1175
x=435, y=827..849
y=1602, x=551..553
x=650, y=175..183
y=690, x=614..642
x=546, y=1277..1293
y=883, x=610..612
x=496, y=1567..1570
x=587, y=992..1019
x=580, y=1324..1351
x=662, y=868..895
y=428, x=441..443
y=1667, x=624..626
x=609, y=375..384
x=477, y=983..985
y=1493, x=473..491
y=23, x=401..407
x=650, y=254..278
y=297, x=520..540
y=1046, x=455..458
x=532, y=1061..1065
y=1062, x=565..583
y=1785, x=662..667
y=733, x=414..433
y=934, x=511..515
x=449, y=1682..1696
x=605, y=842..844
x=514, y=78..80
y=1836, x=408..410
x=455, y=1042..1046
x=546, y=1878..1890
x=492, y=920..926
x=569, y=1665..1688
y=1570, x=496..499
x=622, y=873..886
x=583, y=570..582
y=97, x=642..662
x=533, y=1430..1443
x=395, y=1434..1442
x=516, y=363..371
x=561, y=1730..1756
y=515, x=443..450
x=654, y=1947..1972
x=627, y=208..231
x=432, y=1652..1672
x=507, y=1282..1291
x=533, y=782..799
x=629, y=985..995
x=423, y=983..995
y=1729, x=391..394
x=390, y=303..320
y=802, x=475..495
y=1534, x=631..634
x=603, y=33..57
x=527, y=1140..1142
y=1571, x=639..661
x=387, y=1278..1281
x=662, y=1453..1455
y=501, x=643..655
x=667, y=1346..1360
y=1403, x=628..655
x=494, y=1705..1718
x=489, y=1049..1058
x=608, y=1881..1891
x=524, y=175..185
x=645, y=282..294
x=513, y=1317..1328
x=421, y=701..709
x=583, y=1028..1039
x=658, y=676..695
x=483, y=1281..1291
x=623, y=1469..1474
x=445, y=1010..1019
x=513, y=711..715
x=598, y=1824..1837
x=578, y=926..928
y=1041, x=530..543
y=1040, x=564..568
y=39, x=496..502
x=658, y=1040..1044
x=523, y=1140..1142
y=1250, x=444..450
x=553, y=1595..1602
x=386, y=1821..1842
x=662, y=79..97
y=97, x=543..563
y=1799, x=521..525
x=535, y=1880..1893
y=724, x=554..563
x=446, y=132..144
x=429, y=864..890
x=588, y=1281..1284
y=1326, x=380..401
x=475, y=848..853
x=458, y=62..64
x=445, y=362..382
x=648, y=1534..1538
x=555, y=1517..1531
y=510, x=486..490
x=402, y=863..869
y=38, x=548..570
x=530, y=1628..1652
x=664, y=1619..1633
y=59, x=499..504
y=1263, x=664..667
x=476, y=823..838
y=350, x=395..400
y=1072, x=406..419
x=605, y=391..402
x=499, y=730..733
x=565, y=833..842
y=1301, x=438..464
x=445, y=1450..1473
y=924, x=482..484
x=463, y=1189..1196
x=463, y=1266..1272
x=570, y=427..439
y=406, x=452..460
y=1631, x=645..655
x=516, y=12..21
x=436, y=1938..1942
y=439, x=482..570
y=1652, x=530..534
x=568, y=388..400
x=459, y=666..678
x=499, y=1567..1570
y=73, x=616..639
y=961, x=428..432
x=479, y=822..838
x=544, y=1731..1756
x=391, y=1675..1691
x=656, y=151..167
x=548, y=20..38
x=638, y=262..274
x=617, y=1221..1248
y=1716, x=600..618
x=551, y=853..864
x=508, y=9..18
x=597, y=1266..1277
x=488, y=346..358
x=496, y=1542..1552
y=102, x=436..455
x=448, y=522..542
x=505, y=365..379
x=511, y=1456..1466
x=530, y=413..415
y=120, x=386..396
x=646, y=1034..1046
x=542, y=895..897
y=639, x=549..552
y=365, x=595..599
x=526, y=1939..1941
x=530, y=1376..1388
x=529, y=715..727
y=531, x=432..438
x=628, y=320..344
y=335, x=542..548
x=567, y=1157..1160
x=650, y=1029..1048
x=621, y=961..974
y=754, x=622..625
x=448, y=306..331
x=639, y=66..73
x=566, y=124..130
x=388, y=1797..1800
x=486, y=865..885
y=1691, x=391..398
y=287, x=586..590
x=433, y=715..733
x=600, y=1590..1595
x=511, y=1222..1231
x=486, y=510..514
x=467, y=1337..1353
x=530, y=1024..1041
y=798, x=486..488
y=1611, x=443..457
y=420, x=523..542
x=417, y=1451..1460
y=1994, x=536..546
y=411, x=566..568
x=575, y=1590..1595
x=528, y=558..568
y=1538, x=648..663
x=577, y=546..557
x=475, y=790..802
x=463, y=284..290
x=577, y=589..601
x=521, y=1398..1407
x=525, y=1751..1754
y=580, x=436..461
y=1360, x=626..649
y=419, x=644..661
x=447, y=92..96
y=920, x=634..639
y=985, x=464..477
x=458, y=949..959
y=822, x=590..592
x=661, y=120..145
y=323, x=477..485
x=395, y=344..350
y=1633, x=658..664
y=1058, x=575..577
y=232, x=636..644
x=485, y=464..473
x=460, y=75..81
x=510, y=1304..1308
x=539, y=1419..1426
x=416, y=894..910
x=581, y=1938..1952
x=626, y=1744..1748
y=1529, x=631..634
x=536, y=847..869
y=995, x=396..423
y=1757, x=520..541
y=521, x=602..604
y=1941, x=503..526
y=90, x=654..656
x=448, y=1092..1112
x=397, y=24..42
x=572, y=1310..1312
x=668, y=363..390
y=726, x=419..426
x=511, y=664..679
y=277, x=522..546
y=1229, x=585..602
x=464, y=983..985
x=657, y=773..794
x=444, y=1386..1391
x=559, y=798..808
x=518, y=767..781
x=583, y=1338..1346
y=1015, x=616..627
y=231, x=606..627
x=636, y=1354..1356
x=535, y=413..415
x=558, y=1524..1546
x=517, y=1050..1058
y=1560, x=427..432
x=457, y=523..533
y=1959, x=591..604
x=537, y=1769..1795
x=423, y=1083..1096
x=654, y=1139..1149
x=565, y=569..582
x=582, y=1797..1799
x=438, y=1667..1677
x=561, y=780..791
x=491, y=1152..1162
x=411, y=914..921
y=695, x=646..658
x=465, y=479..491
y=1757, x=441..446
y=787, x=624..637
x=503, y=484..494
x=495, y=1578..1587
x=551, y=1157..1160
y=143, x=467..482
x=508, y=1619..1633
y=1628, x=499..502
x=637, y=614..618
x=402, y=1524..1541
x=586, y=276..287
x=602, y=494..496
x=639, y=1006..1020
x=488, y=464..473
x=395, y=1887..1895
x=563, y=1664..1688
y=1401, x=387..399
x=512, y=95..105
y=1388, x=514..530
y=1329, x=453..459
x=461, y=419..420
y=1187, x=516..670
x=497, y=136..146
x=619, y=1402..1410
x=621, y=239..252
x=592, y=321..336
y=1356, x=634..636
x=387, y=1434..1442
y=1421, x=514..516
x=408, y=336..353
x=541, y=1433..1446
x=523, y=1414..1424
x=599, y=1525..1530
y=982, x=530..538
y=1281, x=387..394
x=383, y=1243..1263
x=547, y=912..938
y=330, x=578..586
x=645, y=459..464
x=393, y=1039..1041
x=394, y=1279..1281
x=531, y=759..771
y=1303, x=418..421
y=955, x=387..405
x=531, y=1703..1713
x=533, y=673..693
x=610, y=878..883
x=452, y=362..374
y=1778, x=642..655
x=534, y=94..105
x=396, y=1755..1764
x=619, y=1420..1424
x=435, y=1772..1786
y=904, x=602..606
x=526, y=175..185
y=76, x=437..442
x=638, y=1752..1764
y=804, x=536..544
y=486, x=415..430
x=440, y=1434..1437
y=513, x=411..433
x=608, y=254..257
y=374, x=583..597
x=451, y=1833..1852
x=446, y=1361..1380
y=1163, x=528..658
y=1882, x=465..483
y=848, x=592..613
x=535, y=244..255
y=562, x=567..583
x=532, y=284..292
x=496, y=1242..1251
x=405, y=929..955
y=1942, x=419..436
y=1135, x=431..442
y=1803, x=380..397
x=487, y=1564..1573
y=213, x=519..535
x=490, y=1602..1604
y=1404, x=512..514
x=626, y=1271..1273
y=637, x=598..616
y=223, x=564..590
y=257, x=589..608
x=647, y=384..393
x=584, y=4..6
x=640, y=1516..1542
x=577, y=1553..1555
y=1754, x=525..529
y=1525, x=523..549
y=688, x=550..571
x=482, y=81..98
x=653, y=1819..1835
x=514, y=1412..1421
x=529, y=303..315
y=1997, x=502..504
x=418, y=18..44
y=518, x=522..531
x=433, y=136..139
y=1751, x=525..529
y=1346, x=583..588
x=503, y=1219..1230
x=667, y=1764..1785
y=1099, x=648..660
x=646, y=675..695
x=655, y=1387..1403
x=510, y=51..64
y=189, x=564..566
x=563, y=960..974
x=599, y=1884..1887
x=419, y=1059..1072
x=595, y=362..365
y=1424, x=504..523
x=443, y=513..515
y=1160, x=551..567
x=576, y=1221..1227
x=533, y=1480..1482
x=493, y=1093..1112
x=527, y=242..250
x=519, y=136..146
y=708, x=542..562
y=908, x=557..571
y=183, x=404..428
x=577, y=1048..1058
y=371, x=514..516
y=779, x=643..649
x=554, y=718..724
x=408, y=1709..1728
y=1990, x=424..442
x=627, y=1015..1017
y=1348, x=514..529
x=561, y=407..417
y=1555, x=552..577
y=1364, x=504..507
x=390, y=1754..1764
x=385, y=788..812
x=505, y=1580..1591
x=473, y=285..290
x=538, y=271..273
y=127, x=438..444
y=250, x=421..438
y=1328, x=513..515
y=803, x=569..572
x=634, y=901..920
x=664, y=1975..1983
y=1549, x=504..506
y=1542, x=625..640
y=350, x=602..624
y=1865, x=540..544
x=405, y=1175..1178
y=609, x=380..386
x=541, y=1746..1757
x=508, y=1493..1507
x=546, y=210..217
x=602, y=1202..1229
y=912, x=516..520
y=1442, x=387..395
y=294, x=617..645
y=992, x=620..623
y=1215, x=410..427
x=588, y=609..621
x=635, y=1280..1307
y=537, x=571..589
y=1089, x=380..386
x=541, y=1832..1843
x=467, y=1433..1437
x=595, y=1078..1080
x=515, y=1127..1148
x=523, y=73..84
x=593, y=946..948
y=166, x=486..531
y=1407, x=506..521
x=631, y=1529..1534
x=415, y=114..129
x=625, y=1225..1243
x=581, y=207..220
x=656, y=175..183
y=64, x=492..510
x=571, y=675..688
x=461, y=558..580
y=240, x=498..513
y=931, x=568..584
y=141, x=510..513
y=1226, x=490..493
x=540, y=1855..1865
x=507, y=1354..1364
y=1835, x=653..655
y=361, x=528..536
x=528, y=1152..1163
y=1275, x=655..666
x=430, y=459..486
x=432, y=1748..1760
y=804, x=628..649
x=656, y=1040..1044
y=1639, x=563..567
x=426, y=213..220
y=1952, x=561..581
y=576, x=573..577
y=1076, x=442..445
x=436, y=349..354
x=401, y=1318..1326
x=410, y=1213..1215
x=568, y=1031..1040
x=503, y=821..825
x=512, y=486..497
x=660, y=1074..1099
y=867, x=507..532
x=578, y=897..909
x=662, y=1347..1360
x=654, y=516..539
x=626, y=160..173
y=44, x=418..434
x=473, y=1643..1653
y=519, x=438..458
x=533, y=1793..1804
y=382, x=424..445
y=1911, x=410..562
x=530, y=1857..1870
x=493, y=1216..1226
x=616, y=1981..1983
x=516, y=245..255
x=495, y=666..669
y=1972, x=633..654
y=1311, x=499..519
x=662, y=1763..1785
x=599, y=941..952
x=651, y=511..523
x=474, y=1498..1499
x=457, y=713..717
x=397, y=1777..1803
y=909, x=578..612
y=1587, x=492..495
x=589, y=946..948
x=662, y=994..1008
x=528, y=349..361
x=602, y=333..350
x=380, y=771..778
x=574, y=1400..1411
y=130, x=566..590
x=380, y=1317..1326
x=512, y=791..795
x=646, y=1883..1889
x=502, y=1623..1628
x=573, y=854..864
x=644, y=401..419
y=1887, x=597..599
x=586, y=1696..1699
x=654, y=868..895
x=600, y=1700..1716
y=744, x=593..614
x=536, y=1578..1583
x=422, y=1708..1728
x=634, y=1354..1356
y=666, x=532..556
y=1882, x=398..414
y=1541, x=400..402
x=416, y=432..438
x=549, y=1456..1468
y=1288, x=494..498
x=449, y=339..342
x=540, y=1540..1543
x=433, y=1370..1374
y=1764, x=631..638
x=600, y=420..444
y=1353, x=439..467
x=637, y=1249..1252
y=1927, x=539..565
x=637, y=843..855
x=532, y=1493..1507
x=450, y=513..515
x=610, y=630..634
x=563, y=718..724
x=473, y=1490..1493
x=629, y=1272..1273
y=1507, x=508..532
y=791, x=561..586
x=635, y=1987..1993
y=496, x=532..548
y=842, x=565..584
x=410, y=1821..1836
x=643, y=489..501
y=523, x=635..651
x=556, y=923..933
x=413, y=232..256
y=1623, x=499..502
x=546, y=263..277
y=933, x=554..556
x=628, y=565..574
x=428, y=1418..1429
x=472, y=762..770
y=1662, x=624..626
x=602, y=1744..1748
x=640, y=344..352
x=424, y=361..382
x=471, y=1536..1552
x=616, y=420..444
x=557, y=1114..1124
x=502, y=507..517
x=464, y=1175..1181
x=576, y=407..417
y=771, x=531..546
y=838, x=476..479
x=522, y=782..799
y=1181, x=464..492
y=517, x=480..502
x=499, y=919..926
x=620, y=850..856
x=560, y=632..642
x=648, y=1073..1099
x=386, y=112..120
x=610, y=489..500
y=1017, x=616..627
y=42, x=487..508
y=539, x=654..664
x=516, y=392..397
y=1019, x=569..587
y=1429, x=409..428
y=523, x=602..604
y=1466, x=511..533
y=1308, x=505..510
x=493, y=343..354
x=432, y=1543..1560
x=605, y=814..816
x=486, y=1189..1196
y=1251, x=534..561
x=566, y=1401..1411
x=642, y=1884..1889
x=406, y=1363..1370
x=464, y=1286..1301
x=620, y=477..490
x=600, y=161..173
x=624, y=333..350
y=770, x=472..494
y=129, x=510..527
x=629, y=30..46
x=604, y=874..886
y=438, x=392..416
x=413, y=1120..1137
y=1293, x=522..546
x=492, y=1578..1587
x=458, y=483..487
x=387, y=930..955
x=610, y=1421..1428
x=464, y=7..32
x=424, y=492..504
y=81, x=460..463
x=609, y=1667..1681
x=598, y=624..637
x=514, y=1400..1404
y=215, x=476..495
y=815, x=532..535
x=457, y=981..991
x=616, y=662..671
x=431, y=1386..1391
x=485, y=1581..1591
x=644, y=958..962
x=442, y=264..267
y=1351, x=578..580
x=482, y=587..595
x=506, y=791..795
y=1710, x=610..612
x=548, y=333..335
x=438, y=238..250
y=1078, x=426..435
y=1645, x=572..596
y=1385, x=539..547
y=1284, x=588..614
y=678, x=448..459
x=462, y=6..32
x=599, y=1028..1039
x=387, y=1962..1974
y=678, x=577..600
y=353, x=387..408
x=579, y=799..808
y=342, x=449..457
y=231, x=544..548
y=1076, x=454..458
x=468, y=1762..1780
y=853, x=470..475
x=484, y=1013..1036
x=579, y=1426..1449
y=808, x=559..579
x=566, y=411..413
y=1543, x=540..547
y=65, x=576..578
x=519, y=1100..1108
x=411, y=863..890
y=1244, x=410..412
x=659, y=774..794
x=621, y=1860..1866
y=504, x=420..424
y=795, x=506..512
x=446, y=1345..1349
x=429, y=767..785
x=519, y=1373..1381
x=469, y=446..459
x=457, y=131..144
x=505, y=1304..1308
x=465, y=1866..1882
x=477, y=316..323
y=905, x=397..406
x=398, y=1039..1041
x=661, y=460..464
x=552, y=630..639
x=590, y=819..822
y=1473, x=434..445
y=210, x=525..529
x=505, y=326..338
x=584, y=207..220
x=529, y=1670..1695
x=523, y=1432..1446
y=1411, x=566..574
y=1677, x=438..445
y=1504, x=432..448
x=583, y=370..374
x=424, y=918..923
y=727, x=529..570
x=637, y=1702..1710
y=1019, x=432..445
x=406, y=1059..1072
y=139, x=418..433
x=529, y=1359..1363
x=567, y=1613..1639
x=493, y=388..400
y=1890, x=544..546
x=648, y=36..40
x=546, y=656..662
y=331, x=448..457
x=568, y=918..931
x=578, y=1323..1351
x=453, y=1322..1329
y=42, x=393..397
x=606, y=1594..1609
y=620, x=509..531
x=386, y=581..609
y=358, x=488..505
x=592, y=819..822
x=432, y=1009..1019
x=461, y=1528..1530
y=1270, x=476..496
y=1033, x=476..478
x=602, y=521..523
x=594, y=302..318
x=623, y=1225..1243
y=123, x=448..467
x=543, y=83..97
y=6, x=584..608
x=424, y=1985..1990
y=1039, x=583..599
y=1304, x=505..510
x=547, y=1541..1543
y=220, x=409..426
x=580, y=965..968
x=582, y=646..650
x=565, y=1050..1062
x=505, y=1660..1671
x=523, y=1373..1381
x=490, y=1216..1226
y=849, x=435..448
x=531, y=155..166
x=538, y=1705..1716
x=495, y=791..802
x=428, y=1004..1005
x=507, y=712..715
x=418, y=587..596
x=442, y=1985..1990
x=483, y=980..991
x=499, y=130..132
y=1905, x=622..641
x=643, y=1213..1219
x=448, y=450..466
x=493, y=80..98
x=572, y=546..557
y=32, x=462..464
y=1227, x=574..576
y=1005, x=489..504
x=642, y=686..690
y=384, x=609..631
y=255, x=516..535
x=467, y=665..669
x=521, y=114..126
x=660, y=1549..1553
y=159, x=567..587
y=1381, x=476..484
x=612, y=1549..1570
x=411, y=489..513
x=615, y=1861..1866
x=558, y=450..462
y=1307, x=623..635
x=459, y=1151..1172
x=489, y=131..132
x=597, y=1359..1362
y=502, x=452..472
x=622, y=33..57
x=539, y=1832..1843
x=645, y=1628..1631
y=1124, x=557..632
x=397, y=900..905
x=634, y=1657..1670
y=1345, x=520..523
x=639, y=478..490
x=546, y=105..113
x=432, y=961..966
x=410, y=1901..1911
y=1804, x=516..533
x=606, y=902..904
y=1181, x=394..414
x=631, y=374..384
y=146, x=497..519
x=498, y=1518..1531
x=554, y=923..933
x=610, y=616..621
y=778, x=380..404
x=610, y=140..144
x=658, y=1152..1163
y=1065, x=532..543
x=632, y=1222..1248
y=778, x=503..509
y=816, x=605..630
x=473, y=870..877
x=638, y=935..948
x=573, y=1919..1931
x=514, y=1357..1367
x=506, y=484..494
y=825, x=573..599
x=635, y=511..523
x=512, y=1400..1404
y=1230, x=485..503
x=538, y=54..57
x=590, y=196..223
y=496, x=600..602
y=1870, x=530..550
y=646, x=582..585
x=433, y=374..376
y=1531, x=498..555
x=645, y=36..40
x=427, y=1214..1215
x=399, y=1616..1643
x=426, y=720..726
y=890, x=411..429
x=533, y=1127..1148
x=597, y=369..374
x=389, y=670..695
x=535, y=1480..1482
x=591, y=643..654
y=54, x=452..455
x=520, y=892..912
x=594, y=1422..1428
y=533, x=457..466
y=155, x=543..553
x=484, y=914..924
y=1058, x=489..517
x=379, y=1986..1999
y=812, x=385..394
y=1362, x=597..607
y=354, x=493..499
x=503, y=776..778
x=662, y=1140..1149
x=435, y=1052..1078
x=597, y=139..144
x=495, y=213..215
y=478, x=476..495
x=552, y=1881..1893
y=1891, x=581..608
x=544, y=1855..1865
y=1629, x=462..464
x=467, y=113..123
y=376, x=433..436
x=423, y=766..785
x=448, y=736..741
x=438, y=1841..1867
x=489, y=996..1005
x=531, y=1768..1781
y=1137, x=411..413
y=991, x=457..483
x=649, y=801..804
x=400, y=344..350
y=132, x=489..499
x=596, y=1385..1389
x=529, y=1751..1754
x=536, y=1003..1006
y=1523, x=650..668
x=501, y=588..595
y=1162, x=491..503
x=567, y=525..537
x=566, y=184..189
x=666, y=1272..1275
y=1999, x=379..393
y=374, x=452..466
y=1889, x=642..646
x=414, y=265..267
x=612, y=51..54
x=589, y=254..257
x=485, y=251..265
x=525, y=197..210
y=1389, x=596..605
y=1312, x=575..594
x=424, y=1343..1351
x=597, y=617..621
y=1381, x=519..523
x=434, y=1725..1738
x=405, y=914..921
x=440, y=1267..1272
x=428, y=1083..1096
y=315, x=527..529
x=498, y=211..216
x=504, y=49..59
x=607, y=856..868
x=641, y=1899..1905
x=488, y=418..420
x=490, y=510..514
x=667, y=1262..1263
y=650, x=582..585
x=592, y=835..848
y=252, x=621..645
x=574, y=144..147
y=1866, x=615..621
x=445, y=1666..1677
y=1153, x=463..470
x=532, y=481..496
y=669, x=467..495
x=442, y=1190..1212
x=491, y=1491..1493
y=703, x=550..554
x=523, y=1525..1527
x=558, y=264..275
y=1175, x=501..506
y=900, x=525..550
x=397, y=1275..1285
x=503, y=1151..1162
y=1008, x=658..662
y=1449, x=575..579
x=520, y=1341..1345
x=393, y=1985..1999
y=1553, x=660..668
x=448, y=828..849
y=320, x=390..410
y=709, x=411..421
x=630, y=391..402
y=1083, x=575..609
x=586, y=327..330
y=191, x=544..551
y=327, x=578..586
y=1485, x=523..542
x=581, y=1725..1751
x=393, y=25..42
y=487, x=389..398
x=548, y=482..496
x=592, y=1695..1699
x=655, y=489..501
y=352, x=640..665
y=974, x=563..621
x=648, y=1307..1320
x=452, y=1747..1760
x=532, y=859..867
x=632, y=1114..1124
y=925, x=443..450
x=389, y=1153..1156
x=661, y=1566..1571
y=600, x=450..477
y=1728, x=408..422
x=418, y=135..139
y=491, x=447..465
y=483, x=455..458
y=1112, x=435..448
x=515, y=1317..1328
x=503, y=1198..1209
x=521, y=1320..1331
x=401, y=1919..1931
x=550, y=676..688
x=504, y=1539..1549
y=1609, x=471..497
y=274, x=638..643
x=571, y=510..537
y=217, x=539..546
y=1595, x=575..600
x=414, y=1870..1882
x=445, y=586..596
x=518, y=590..608
x=546, y=759..771
y=1273, x=626..629
x=631, y=1752..1764
x=668, y=1509..1523
y=952, x=578..599
x=416, y=987..990
y=948, x=617..638
x=618, y=1453..1476
x=485, y=1218..1230
x=620, y=552..580
x=433, y=489..513
y=969, x=423..438
y=64, x=458..462
y=938, x=547..564
x=412, y=632..651
y=46, x=629..655
x=458, y=509..519
x=466, y=523..533
x=435, y=1091..1112
x=407, y=11..23
x=504, y=1415..1424
y=1067, x=480..485
x=534, y=1250..1251
x=565, y=642..654
y=959, x=454..458
x=570, y=716..727
x=515, y=178..188
x=498, y=1286..1288
x=410, y=1231..1244
x=529, y=1338..1348
y=1285, x=397..419
x=540, y=287..297
x=624, y=1093..1104
x=562, y=1901..1911
y=557, x=572..577
x=457, y=1606..1611
x=564, y=1030..1040
y=1527, x=523..549
x=384, y=710..731
x=600, y=494..496
x=450, y=598..600
x=635, y=661..671
y=185, x=524..526
x=452, y=449..466
x=567, y=153..159
y=175, x=438..450
x=624, y=1662..1667
x=401, y=12..23
x=660, y=255..278
y=897, x=535..542