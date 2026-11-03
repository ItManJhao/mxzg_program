package com.ayjs.mxzg.tools.generate;


import cn.hutool.core.util.StrUtil;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@Slf4j
public class GenerateTruncateLog {

    public static LocalDate localDateStart = LocalDate.of(2020, 11, 1);
    public static LocalDate localDateEnd = LocalDate.of(2021, 4, 1);

    public static int serverIdStart = 1001;
    public static int serverIdEnd = 1017;

    public static void main(String[] args) {
        List<String> tables = getTables();
        LocalDate tempDate = localDateEnd;
        // 按照顺序清除不用的日志库
//        String sqlTemplate = "truncate table mxzg_{}_log.{}_{}_{};";
//        while (tempDate.isAfter(localDateStart)) {
//
//            for (int i = serverIdStart; i <= serverIdEnd; i++) {
//                for (String table : tables) {
//                    String sql = StrUtil.format(sqlTemplate, i, table, tempDate.getYear(),
//                            StrUtil.fill(String.valueOf(tempDate.getMonth().getValue()),'0',2,true));
//                    System.out.println(sql);
//                }
//            }
//            tempDate = tempDate.minusMonths(1);
//        }

        // 按照指定数据库删除不用的日志数据
        List<String> dbs = getDBs();
//        String sqlTemplate2 = "truncate table {}.{}_{}_{};";
//        while (tempDate.isAfter(localDateStart)) {
//
//            for (String dbname : dbs) {
//                for (String table : tables) {
//                    String sql = StrUtil.format(sqlTemplate2, dbname, table, tempDate.getYear(),
//                            StrUtil.fill(String.valueOf(tempDate.getMonth().getValue()), '0', 2, true));
//                    System.out.println(sql);
//                }
//            }
//            tempDate = tempDate.minusMonths(1);
//        }

        // 删除 战报数据
        String sqlTemplate3 = "delete from {}.video_role where kind = 1 and time < 1617206400;";
//        String sqlTemplate3 = "delete from {}.video_role where kind = 1 and time < 1617206400;optimize table {}.video_role;";
        for (String dbname : dbs) {
            String dataName = dbname.replace("_log", "_data");
            String sql = StrUtil.format(sqlTemplate3, dataName, dataName);
            System.out.println(sql);
        }
    }

    public static List<String> getTables() {
//        return Lists.newArrayList(
//                "item_log_monthly",
//                "gold_log_monthly",
//                "mail_log_monthly",
//                "hero_log_monthly"
//        );
        return Lists.newArrayList(
                "battle_log_monthly",
                "dungeon_log_monthly",
                "hero_train_log_monthly",
                "hero_fighting_log_monthly",
                "hero_exp_log_monthly",
                "shop_log_monthly",
                "tavern_adventure_log_monthly",
                "tower_log_monthly",
                "rune_log_monthly",
                "role_fighting_log_monthly",
                "role_exp_log_monthly");
    }

    public static List<String> getDBs() {
        List<String> dbs = Arrays.asList(
                "mxzg_1_log"
                , "mxzg_2_log"
                , "mxzg_4_log"
                , "mxzg_6_log"
                , "mxzg_8_log"
                , "mxzg_11_log"
                , "mxzg_14_log"
                , "mxzg_21_log"
                , "mxzg_26_log"
                , "mxzg_31_log"
                , "mxzg_36_log"
                , "mxzg_41_log"
                , "mxzg_46_log"
                , "mxzg_51_log"
                , "mxzg_56_log"
                , "mxzg_61_log"
                , "mxzg_66_log"
                , "mxzg_71_log"
                , "mxzg_76_log"
                , "mxzg_81_log"
                , "mxzg_86_log"
                , "mxzg_91_log"
                , "mxzg_96_log"
                , "mxzg_101_log"
                , "mxzg_106_log"
                , "mxzg_111_log"
                , "mxzg_116_log"
                , "mxzg_121_log"
                , "mxzg_126_log"
                , "mxzg_131_log"
                , "mxzg_136_log"
                , "mxzg_141_log"
                , "mxzg_146_log"
                , "mxzg_151_log"
                , "mxzg_156_log"
                , "mxzg_161_log"
                , "mxzg_165_log"
                , "mxzg_171_log"
                , "mxzg_176_log"
                , "mxzg_181_log"
                , "mxzg_186_log"
                , "mxzg_191_log"
                , "mxzg_196_log"
                , "mxzg_200_log"
                , "mxzg_201_log"
                , "mxzg_206_log"
                , "mxzg_211_log"
                , "mxzg_216_log"
                , "mxzg_221_log"
                , "mxzg_226_log"
                , "mxzg_231_log"
                , "mxzg_236_log"
                , "mxzg_241_log"
                , "mxzg_246_log"
                , "mxzg_251_log"
                , "mxzg_256_log"
                , "mxzg_261_log"
                , "mxzg_266_log"
                , "mxzg_271_log"
                , "mxzg_276_log"
                , "mxzg_281_log"
                , "mxzg_284_log"
                , "mxzg_286_log"
                , "mxzg_288_log"
                , "mxzg_291_log"
                , "mxzg_296_log"
                , "mxzg_301_log"
                , "mxzg_306_log"
                , "mxzg_311_log"
                , "mxzg_313_log"
                , "mxzg_316_log"
                , "mxzg_318_log"
                , "mxzg_321_log"
                , "mxzg_323_log"
                , "mxzg_325_log"
                , "mxzg_327_log"
                , "mxzg_329_log"
                , "mxzg_331_log"
                , "mxzg_333_log"
                , "mxzg_335_log"
                , "mxzg_337_log"
                , "mxzg_339_log"
                , "mxzg_341_log"
                , "mxzg_343_log"
                , "mxzg_345_log"
                , "mxzg_347_log"
                , "mxzg_349_log"
                , "mxzg_351_log"
                , "mxzg_353_log"
                , "mxzg_356_log"
                , "mxzg_359_log"
                , "mxzg_361_log"
                , "mxzg_363_log"
                , "mxzg_365_log"
                , "mxzg_367_log"
                , "mxzg_369_log"
                , "mxzg_371_log"
                , "mxzg_373_log"
                , "mxzg_375_log"
                , "mxzg_377_log"
                , "mxzg_379_log"
                , "mxzg_381_log"
                , "mxzg_383_log"
                , "mxzg_385_log"
                , "mxzg_387_log"
                , "mxzg_389_log"
                , "mxzg_391_log"
                , "mxzg_393_log"
                , "mxzg_395_log"
                , "mxzg_397_log"
                , "mxzg_399_log"
                , "mxzg_401_log"
                , "mxzg_405_log"
                , "mxzg_407_log"
                , "mxzg_409_log"
                , "mxzg_411_log"
                , "mxzg_413_log"
                , "mxzg_415_log"
                , "mxzg_417_log"
                , "mxzg_419_log"
                , "mxzg_421_log"
                , "mxzg_424_log"
                , "mxzg_426_log"
                , "mxzg_429_log"
                , "mxzg_431_log"
                , "mxzg_433_log"
                , "mxzg_435_log"
                , "mxzg_437_log"
                , "mxzg_439_log"
                , "mxzg_441_log"
                , "mxzg_443_log"
                , "mxzg_445_log"
                , "mxzg_447_log"
                , "mxzg_449_log"
                , "mxzg_451_log"
                , "mxzg_453_log"
                , "mxzg_455_log"
                , "mxzg_457_log"
                , "mxzg_459_log"
                , "mxzg_461_log"
                , "mxzg_464_log"
                , "mxzg_467_log"
                , "mxzg_469_log"
                , "mxzg_471_log"
                , "mxzg_473_log"
                , "mxzg_475_log"
                , "mxzg_477_log"
                , "mxzg_479_log"
                , "mxzg_481_log"
                , "mxzg_483_log"
                , "mxzg_485_log"
                , "mxzg_487_log"
                , "mxzg_489_log"
                , "mxzg_491_log"
                , "mxzg_493_log"
                , "mxzg_495_log"
                , "mxzg_497_log"
                , "mxzg_499_log"
                , "mxzg_501_log"
                , "mxzg_503_log"
                , "mxzg_505_log"
                , "mxzg_506_log"
                , "mxzg_507_log"
                , "mxzg_508_log"
                , "mxzg_509_log"
                , "mxzg_510_log"
                , "mxzg_511_log"
                , "mxzg_512_log"
                , "mxzg_513_log"
                , "mxzg_514_log"
                , "mxzg_515_log"
                , "mxzg_516_log"
                , "mxzg_517_log"
                , "mxzg_518_log"
                , "mxzg_519_log"
                , "mxzg_520_log"
                , "mxzg_521_log"
                , "mxzg_522_log"
                , "mxzg_523_log"
                , "mxzg_524_log"
                , "mxzg_525_log"
                , "mxzg_526_log"
                , "mxzg_527_log"
                , "mxzg_528_log"
                , "mxzg_529_log"
                , "mxzg_530_log"
                , "mxzg_531_log"
                , "mxzg_533_log"
                , "mxzg_535_log"
                , "mxzg_537_log"
                , "mxzg_539_log"
                , "mxzg_541_log"
                , "mxzg_544_log"
                , "mxzg_547_log"
                , "mxzg_549_log"
                , "mxzg_551_log"
                , "mxzg_554_log"
                , "mxzg_556_log"
                , "mxzg_557_log"
                , "mxzg_558_log"
                , "mxzg_559_log"
                , "mxzg_560_log"
                , "mxzg_561_log"
                , "mxzg_562_log"
                , "mxzg_563_log"
                , "mxzg_564_log"
                , "mxzg_565_log"
                , "mxzg_566_log"
                , "mxzg_567_log"
                , "mxzg_568_log"
                , "mxzg_569_log"
                , "mxzg_570_log"
                , "mxzg_571_log"
                , "mxzg_572_log"
                , "mxzg_573_log"
                , "mxzg_574_log"
                , "mxzg_575_log"
                , "mxzg_576_log"
                , "mxzg_577_log"
                , "mxzg_578_log"
                , "mxzg_579_log"
                , "mxzg_580_log"
                , "mxzg_581_log"
                , "mxzg_582_log"
                , "mxzg_583_log"
                , "mxzg_584_log"
                , "mxzg_585_log"
                , "mxzg_586_log"
                , "mxzg_587_log"
                , "mxzg_588_log"
                , "mxzg_589_log"
                , "mxzg_590_log"
                , "mxzg_591_log"
                , "mxzg_592_log"
                , "mxzg_593_log"
                , "mxzg_594_log"
                , "mxzg_595_log"
                , "mxzg_596_log"
                , "mxzg_597_log"
                , "mxzg_598_log"
                , "mxzg_599_log"
                , "mxzg_600_log"
                , "mxzg_601_log"
                , "mxzg_602_log"
                , "mxzg_603_log"
                , "mxzg_604_log"
                , "mxzg_605_log"
                , "mxzg_606_log"
                , "mxzg_607_log"
                , "mxzg_608_log"
                , "mxzg_609_log"
                , "mxzg_610_log"
                , "mxzg_611_log"
                , "mxzg_612_log"
                , "mxzg_613_log"
                , "mxzg_614_log"
                , "mxzg_615_log"
                , "mxzg_616_log"
                , "mxzg_617_log"
                , "mxzg_618_log"
                , "mxzg_619_log"
                , "mxzg_620_log");
        return dbs;
    }
}
