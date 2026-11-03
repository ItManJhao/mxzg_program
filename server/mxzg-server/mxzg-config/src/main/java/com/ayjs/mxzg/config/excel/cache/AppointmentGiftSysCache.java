package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CAppointmentGift;
import org.springframework.stereotype.Component;

@Component
public class AppointmentGiftSysCache extends BaseExcelCache<CAppointmentGift> {

    @Override
    public String getFileName() {
        return "appointmentgift";
    }

    @Override
    protected void loadAfterReady() {
        super.loadAfterReady();
    }

    /**
     * 是否享有预约福利
     * @param versions
     * @return
     */
    public boolean isGift(int versions) {
        for (CAppointmentGift gift : this.getAll()) {
            if(gift.getVersions().contains(versions)){
               return true;
            }
        }
        return false;
    }

    /**
     * 是否享有创号预约礼包福利
     *
     * @param versions
     * @return
     */
    public boolean isCreateGift(int versions) {
        CAppointmentGift cAppointmentGift = this.getAll().stream().filter(config -> config.getGift_type() == 0).findFirst().orElse(null);
        if (cAppointmentGift != null) {
            return cAppointmentGift.getVersions().contains(versions);
        }
        return false;
    }

    /**
     * 是否享有登陆礼包福利
     *
     * @param versions
     * @return
     */
    public boolean isLoginGift(int versions) {
        CAppointmentGift cAppointmentGift = this.getAll().stream().filter(config -> config.getGift_type() == 1).findFirst().orElse(null);
        if (cAppointmentGift != null) {
            return cAppointmentGift.getVersions().contains(versions);
        }
        return false;
    }

}
