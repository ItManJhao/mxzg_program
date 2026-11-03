package com.ayjs.mxzg.gameserver.log.pet.dao;

import com.ayjs.mxzg.common.persistence.log.BaseLogRepository;
import com.ayjs.mxzg.gameserver.log.pet.domain.PetLog;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import org.springframework.stereotype.Repository;

@Repository
public class PetLogDao extends BaseLogRepository<PetLog> {
}
