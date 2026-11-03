package com.ayjs.mxzg.gameserver.module.pet.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.pet.domain.Pet;
import org.springframework.stereotype.Component;

@Component
public class PetDao extends BaseRepository<Pet> {
}
