class PetArrayRightTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class ModeTemplate extends  ConfigInfo{
	public id:number;
	public res:string;
	public hight:number;

	public attrs(){
		return ['id','res','hight'];
	}
}

class MagicEggHoleOpenTemplate extends  ConfigInfo{
	public id:number;
	public openLevel:number;
	public openVip:number;

	public attrs(){
		return ['id','openLevel','openVip'];
	}
}

class AnswerRankRewardTemplate extends  ConfigInfo{
	public id:number;
	public minRank:number;
	public maxRank:number;
	public des:number;
	public reward:any;

	public attrs(){
		return ['id','minRank','maxRank','des','reward'];
	}
}

class DailyAnswerTemplate extends  ConfigInfo{
	public id:number;
	public rightExp:number;
	public rightGold:any;
	public falseExp:number;
	public falseGold:any;

	public attrs(){
		return ['id','rightExp','rightGold','falseExp','falseGold'];
	}
}

class FundTemplate extends  ConfigInfo{
	public id:number;
	public day:number;
	public reward:any;

	public attrs(){
		return ['id','day','reward'];
	}
}

class FlopTemplate extends  ConfigInfo{
	public id:number;
	public reward:any;
	public consume:any;

	public attrs(){
		return ['id','reward','consume'];
	}
}

class XianlvshengxingTemplate extends  ConfigInfo{
	public ID:number;
	public prostarconsume:any;
	public skillid:number;

	public attrs(){
		return ['ID','prostarconsume','skillid'];
	}
}

class DevilgirlWeaponTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class PetTemplate extends  ConfigInfo{
	public id:number;
	public activeProp:any;
	public activeAttr:any;
	public aptitudeCardAttr:any;
	public quality:number;
	public element:any;
	public activeSkill:number;
	public passiveSkillGrid:number;
	public initPassiveSkills:any;
	public icon:string;
	public model:number;
	public name:number;
	public phyle:number;
	public sort:number;
	public HPAptitude:any;
	public PhyAptitude:any;
	public SplAptitude:any;
	public DefAptitude:any;
	public feedCost:any;

	public attrs(){
		return ['id','activeProp','activeAttr','aptitudeCardAttr','quality','element','activeSkill','passiveSkillGrid','initPassiveSkills','icon','model','name','phyle','sort','HPAptitude','PhyAptitude','SplAptitude','DefAptitude','feedCost'];
	}
}

class SkilleventTemplate extends  ConfigInfo{
	public skilleventid:number;
	public actactionkey:number;
	public acteffectid:Array<number>;
	public ballisticeffect:number;
	public hiteffectid:number;
	public explosioneffectid:number;
	public position:number;

	public attrs(){
		return ['skilleventid','actactionkey','acteffectid','ballisticeffect','hiteffectid','explosioneffectid','position'];
	}
}

class DefaultEquipIconTemplate extends  ConfigInfo{
	public id:number;
	public funType:number;
	public part:number;
	public icon:string;

	public attrs(){
		return ['id','funType','part','icon'];
	}
}

class TotalRechargeTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public rechargeNum:number;
	public des:number;
	public reward:any;
	public order:number;
	public goTo:any;

	public attrs(){
		return ['id','businessActivitiesId','number','rechargeNum','des','reward','order','goTo'];
	}
}

class EquipSmeltTemplate extends  ConfigInfo{
	public ID:number;
	public type:number;
	public level:any;
	public quality:number;
	public rewardsID:any;

	public attrs(){
		return ['ID','type','level','quality','rewardsID'];
	}
}

class SignTemplate extends  ConfigInfo{
	public id:number;
	public day:number;
	public reward:any;

	public attrs(){
		return ['id','day','reward'];
	}
}

class AttributeTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public attribute:any;
	public uselimit:number;

	public attrs(){
		return ['id','type','attribute','uselimit'];
	}
}

class BattleHelpTemplate extends  ConfigInfo{
	public id:number;
	public rewardTimes:number;
	public reward:any;

	public attrs(){
		return ['id','rewardTimes','reward'];
	}
}

class PropTemplate extends  ConfigInfo{
	public id:number;
	public level:any;
	public icon:string;
	public name:number;
	public type:number;
	public value:any;
	public quality:number;
	public operation:number;
	public redPoint:number;
	public des:number;
	public openUI:any;
	public numLimit:number;
	public timeLimit:any;
	public autoDestory:number;
	public haveNum:number;
	public power:any;
	public score:number;
	public showShape:any;
	public getPath:any;
	public tag:number;
	public fragmentTag:number;
	public shopID:number;

	public attrs(){
		return ['id','level','icon','name','type','value','quality','operation','redPoint','des','openUI','numLimit','timeLimit','autoDestory','haveNum','power','score','showShape','getPath','tag','fragmentTag','shopID'];
	}
}

class ForgeSuitTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public level:number;
	public attribute:any;

	public attrs(){
		return ['id','type','level','attribute'];
	}
}

class BaptizeTemplate extends  ConfigInfo{
	public id:number;
	public part:number;
	public typecost:any;
	public attributecost:any;
	public value:any;

	public attrs(){
		return ['id','part','typecost','attributecost','value'];
	}
}

class MagicEggSkillTemplate extends  ConfigInfo{
	public id:number;
	public Skillup:any;

	public attrs(){
		return ['id','Skillup'];
	}
}

class SweeneyTemplate extends  ConfigInfo{
	public id:number;
	public levelInterval:any;
	public reward100:any;
	public reward200:any;
	public reward300:any;

	public attrs(){
		return ['id','levelInterval','reward100','reward200','reward300'];
	}
}

class TreasureGuaranteeTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public smalltype:number;
	public reward:any;
	public probability:number;
	public broadcast:number;

	public attrs(){
		return ['id','type','smalltype','reward','probability','broadcast'];
	}
}

class MonsterAttributeTemplate extends  ConfigInfo{
	public id:number;
	public maxHp:number;
	public physicalattack:number;
	public physicaldefense:number;
	public spellattack:number;
	public spelldefence:number;
	public physicalhit:number;
	public physicaldodge:number;
	public spellhit:number;
	public spelldodge:number;
	public physicalincrease:number;
	public physicalreduced:number;
	public spellincrease:number;
	public spellreducrd:number;
	public physicalcritincrease:number;
	public physicalcritreduced:number;
	public spellcritincrease:number;
	public spellcritreduced:number;
	public shield:number;
	public hitchance:number;
	public dogechance:number;
	public critchance:number;
	public critdefchance:number;
	public gold:number;
	public wood:number;
	public water:number;
	public fire:number;
	public earth:number;
	public light:number;
	public dark:number;

	public attrs(){
		return ['id','maxHp','physicalattack','physicaldefense','spellattack','spelldefence','physicalhit','physicaldodge','spellhit','spelldodge','physicalincrease','physicalreduced','spellincrease','spellreducrd','physicalcritincrease','physicalcritreduced','spellcritincrease','spellcritreduced','shield','hitchance','dogechance','critchance','critdefchance','gold','wood','water','fire','earth','light','dark'];
	}
}

class CrossServerMineTemplate extends  ConfigInfo{
	public id:number;
	public mineQuality:number;
	public collecttime:number;
	public refreshTime:number;
	public mineNum:number;
	public mineModel:string;
	public mineCar:number;
	public rewards:any;
	public points:number;

	public attrs(){
		return ['id','mineQuality','collecttime','refreshTime','mineNum','mineModel','mineCar','rewards','points'];
	}
}

class GrowFundActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public investmentNumType:number;
	public level:number;
	public reward:any;
	public des:number;

	public attrs(){
		return ['id','businessActivitiesId','number','investmentNumType','level','reward','des'];
	}
}

class InnerForceTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public stage:number;
	public cost:any;
	public attrbutite:any;

	public attrs(){
		return ['id','level','stage','cost','attrbutite'];
	}
}

class SpuerSkinTemplate extends  ConfigInfo{
	public id:number;
	public skinList:any;
	public attrTwo:any;
	public attrThree:any;
	public attrFour:any;
	public name:number;

	public attrs(){
		return ['id','skinList','attrTwo','attrThree','attrFour','name'];
	}
}

class FactionDugeonTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public level:number;
	public monster:number;
	public scence:number;
	public fistPassReward:any;
	public passReward:any;
	public dropShow:any;

	public attrs(){
		return ['id','name','level','monster','scence','fistPassReward','passReward','dropShow'];
	}
}

class ClientActivityTypeTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public name:number;
	public btnType:string;
	public mainUiBtn:string;
	public showCountdown:number;
	public mainUiBtnPos:string;
	public order:string;
	public deleteBtn:number;

	public attrs(){
		return ['id','type','name','btnType','mainUiBtn','showCountdown','mainUiBtnPos','order','deleteBtn'];
	}
}

class MagicEggDecoTemplate extends  ConfigInfo{
	public id:number;
	public getMaterial:any;

	public attrs(){
		return ['id','getMaterial'];
	}
}

class MonsterTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public type:number;
	public level:number;
	public model:number;
	public baseSkill:number;
	public passiveSkillList:any;
	public modelpeople:number;
	public mounts:number;
	public wing:number;
	public weapon:number;
	public sex:number;
	public race:number;

	public attrs(){
		return ['id','name','type','level','model','baseSkill','passiveSkillList','modelpeople','mounts','wing','weapon','sex','race'];
	}
}

class DiscountShopActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public content:any;
	public price:any;
	public cost:any;
	public purchaseLimit:number;
	public numLimit:number;
	public showLevel:number;
	public unlockCondition:number;
	public value:number;
	public lockDes:number;
	public disappear:number;
	public order:number;
	public redPointType:number;
	public selectNum:number;

	public attrs(){
		return ['id','businessActivitiesId','number','content','price','cost','purchaseLimit','numLimit','showLevel','unlockCondition','value','lockDes','disappear','order','redPointType','selectNum'];
	}
}

class ForgeIconTemplate extends  ConfigInfo{
	public id:number;
	public function:number;
	public part:number;
	public icon:string;

	public attrs(){
		return ['id','function','part','icon'];
	}
}

class AnswerTemplate extends  ConfigInfo{
	public id:number;
	public topic:number;
	public option1:number;
	public option2:number;
	public option3:number;
	public option4:number;

	public attrs(){
		return ['id','topic','option1','option2','option3','option4'];
	}
}

class DropGroupTemplate extends  ConfigInfo{
	public dropGroupId:number;
	public drops:any;

	public attrs(){
		return ['dropGroupId','drops'];
	}
}

class FactionBankTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public minInput:number;
	public maxInput:number;
	public reward:any;

	public attrs(){
		return ['id','type','minInput','maxInput','reward'];
	}
}

class WestboundBackTemplate extends  ConfigInfo{
	public id:number;
	public minLevel:number;
	public maxLevel:number;
	public reward1:any;
	public reward2:any;
	public reward3:any;
	public reward4:any;
	public reward5:any;
	public reward6:any;
	public reward7:any;

	public attrs(){
		return ['id','minLevel','maxLevel','reward1','reward2','reward3','reward4','reward5','reward6','reward7'];
	}
}

class MapBossTemplate extends  ConfigInfo{
	public id:number;
	public monsterGroup:number;
	public mapId:number;
	public rewardShow:any;
	public color:number;
	public itemResurrectionConsume:any;
	public moneyResurrectionConsume:any;
	public resurrectionCD:number;
	public challengeReward:number;
	public firstReward:number;
	public notFirstReward:number;

	public attrs(){
		return ['id','monsterGroup','mapId','rewardShow','color','itemResurrectionConsume','moneyResurrectionConsume','resurrectionCD','challengeReward','firstReward','notFirstReward'];
	}
}

class SpecifyRechargeTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public rechargeId:number;
	public des:number;
	public reward:any;
	public order:number;

	public attrs(){
		return ['id','businessActivitiesId','number','rechargeId','des','reward','order'];
	}
}

class ActivitiesTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public showType:number;
	public name:number;
	public advanceNoticeTime:string;
	public openTime:string;
	public endTime:string;
	public timeDes:number;
	public advanceNoticeId:number;
	public openNoticeId:number;
	public lockDes:number;
	public rewardShow:any;
	public order:number;
	public openPrompt:number;

	public attrs(){
		return ['id','type','showType','name','advanceNoticeTime','openTime','endTime','timeDes','advanceNoticeId','openNoticeId','lockDes','rewardShow','order','openPrompt'];
	}
}

class FightTypeTemplate extends  ConfigInfo{
	public id:number;
	public armyType:number;
	public attackSee:number;
	public attackedSee:number;
	public maxRound:number;
	public canSkip:number;
	public passSkip:number;
	public skipRound:number;
	public skipVip:number;
	public skipLevel:number;
	public FightName:number;
	public FightDisc:number;
	public BackGround:number;
	public music:number;
	public showBOSS:number;

	public attrs(){
		return ['id','armyType','attackSee','attackedSee','maxRound','canSkip','passSkip','skipRound','skipVip','skipLevel','FightName','FightDisc','BackGround','music','showBOSS'];
	}
}

class DressTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public condition:any;
	public att:any;
	public model0:number;
	public model1:number;

	public attrs(){
		return ['id','name','condition','att','model0','model1'];
	}
}

class ExchangeActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public cost:any;
	public reward:any;
	public exchageTimes:number;
	public order:number;

	public attrs(){
		return ['id','businessActivitiesId','number','cost','reward','exchageTimes','order'];
	}
}

class MasterAndApprenticeTemplate extends  ConfigInfo{
	public type:number;
	public name:number;
	public condition:number;
	public apprenticeExp:number;
	public masterReward:any;
	public order:number;

	public attrs(){
		return ['type','name','condition','apprenticeExp','masterReward','order'];
	}
}

class GqdituTemplate extends  ConfigInfo{
	public id:number;
	public maxOutpost:number;
	public awards:any;
	public openLevel:number;
	public monsterNum:number;
	public mapId:number;
	public name:number;
	public nextId:number;
	public icon:string;
	public music:number;

	public attrs(){
		return ['id','maxOutpost','awards','openLevel','monsterNum','mapId','name','nextId','icon','music'];
	}
}

class FactionLevelTemplate extends  ConfigInfo{
	public level:number;
	public exp:number;
	public attr:any;
	public num:number;
	public postNum:Array<number>;
	public bossId:number;
	public challengeRewardShow:any;
	public challengeReward:number;
	public killRewardShow:any;
	public killReward:number;

	public attrs(){
		return ['level','exp','attr','num','postNum','bossId','challengeRewardShow','challengeReward','killRewardShow','killReward'];
	}
}

class CrossServerMineRankTemplate extends  ConfigInfo{
	public id:number;
	public des:number;
	public rewards:any;

	public attrs(){
		return ['id','des','rewards'];
	}
}

class DropTemplate extends  ConfigInfo{
	public dropId:number;
	public dropItems:any;

	public attrs(){
		return ['dropId','dropItems'];
	}
}

class ChatDefaultWordTemplate extends  ConfigInfo{
	public id:number;
	public des:number;

	public attrs(){
		return ['id','des'];
	}
}

class FirstRechargeGroupPurchaseTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public groupNum:number;
	public rechargeNum:number;
	public reward:any;
	public des:number;

	public attrs(){
		return ['id','businessActivitiesId','number','groupNum','rechargeNum','reward','des'];
	}
}

class CumulativeOnlineRewardTemplate extends  ConfigInfo{
	public id:number;
	public time:number;
	public reward:any;
	public des:number;

	public attrs(){
		return ['id','time','reward','des'];
	}
}

class RoleLevelExpTemplate extends  ConfigInfo{
	public level:number;
	public exp:number;
	public maxexp:number;

	public attrs(){
		return ['level','exp','maxexp'];
	}
}

class MailTemplate extends  ConfigInfo{
	public id:number;
	public title:number;
	public content:number;

	public attrs(){
		return ['id','title','content'];
	}
}

class DataLevelTemplate extends  ConfigInfo{
	public id:number;
	public languageId:number;
	public levelName:string;
	public openLevel:number;
	public monsterListId:number;
	public reward:any;
	public flopRewardId:number;
	public sweepLevel:number;

	public attrs(){
		return ['id','languageId','levelName','openLevel','monsterListId','reward','flopRewardId','sweepLevel'];
	}
}

class TherionActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public level:number;
	public name:number;
	public monsterGroupId:number;
	public reward:any;

	public attrs(){
		return ['id','businessActivitiesId','number','level','name','monsterGroupId','reward'];
	}
}

class FactionRedPacketTemplate extends  ConfigInfo{
	public type:number;
	public name:number;
	public condition:number;
	public conditionValue:number;
	public defaultNum:number;
	public minNum:number;
	public maxNum:number;
	public amount:number;

	public attrs(){
		return ['type','name','condition','conditionValue','defaultNum','minNum','maxNum','amount'];
	}
}

class TitleTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public condition:any;
	public att:any;
	public icon:string;

	public attrs(){
		return ['id','name','condition','att','icon'];
	}
}

class WeaponSpiritSkinTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public attribute:any;
	public cost:any;
	public model:number;

	public attrs(){
		return ['id','name','attribute','cost','model'];
	}
}

class TreasureShowTemplate extends  ConfigInfo{
	public id:number;
	public rewardShow:any;
	public rarity:number;

	public attrs(){
		return ['id','rewardShow','rarity'];
	}
}

class ArtifactTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name1:number;
	public name2:number;
	public name3:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model1:number;
	public model2:number;
	public model3:number;

	public attrs(){
		return ['id','level','name1','name2','name3','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model1','model2','model3'];
	}
}

class LoginActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public days:number;
	public des:number;
	public reward:any;
	public mainUiBtn:string;
	public mainUiDes:number;

	public attrs(){
		return ['id','businessActivitiesId','number','days','des','reward','mainUiBtn','mainUiDes'];
	}
}

class EquipmentSuitTemplate extends  ConfigInfo{
	public level:number;
	public condition:any;
	public attr:any;

	public attrs(){
		return ['level','condition','attr'];
	}
}

class SignRewardTemplate extends  ConfigInfo{
	public id:number;
	public day:number;
	public signReward:any;
	public vipReward:any;
	public rechargeReward:any;

	public attrs(){
		return ['id','day','signReward','vipReward','rechargeReward'];
	}
}

class CrossServerCraftRefreshTemplate extends  ConfigInfo{
	public layer:number;
	public maxCell:number;
	public symbolNum:number;
	public symbolRefresh:any;
	public scoreNum:number;
	public scoreRefresh:any;

	public attrs(){
		return ['layer','maxCell','symbolNum','symbolRefresh','scoreNum','scoreRefresh'];
	}
}

class InvestActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public days:number;
	public reward:any;

	public attrs(){
		return ['id','businessActivitiesId','number','days','reward'];
	}
}

class FactionTaskRewardTemplate extends  ConfigInfo{
	public guildLevel:number;
	public collectReward:any;
	public monsterReward:any;
	public collectDrop:number;
	public monsterDrop:number;

	public attrs(){
		return ['guildLevel','collectReward','monsterReward','collectDrop','monsterDrop'];
	}
}

class LoginTemplate extends  ConfigInfo{
	public id:number;
	public day:number;
	public loginReward:any;
	public rewardShow:any;

	public attrs(){
		return ['id','day','loginReward','rewardShow'];
	}
}

class FactionPrayValueTemplate extends  ConfigInfo{
	public id:number;
	public rewardValue:number;
	public reward:any;

	public attrs(){
		return ['id','rewardValue','reward'];
	}
}

class AmbitTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public icon:string;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','icon'];
	}
}

class RechargeTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public name:number;
	public money:number;
	public icon:string;
	public des:number;
	public jadeNum:number;
	public extraJade:number;
	public btnDes:number;
	public showAfterRecharge:number;
	public isShow:number;
	public key:string;

	public attrs(){
		return ['id','type','name','money','icon','des','jadeNum','extraJade','btnDes','showAfterRecharge','isShow','key'];
	}
}

class DragonMonsterTemplate extends  ConfigInfo{
	public id:number;
	public mapId:number;
	public outpost:number;
	public bosslist:number;
	public monsterlist:number;
	public model:number;
	public reward:Array<number>;

	public attrs(){
		return ['id','mapId','outpost','bosslist','monsterlist','model','reward'];
	}
}

class PetArrayMidTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class ExperienceScoreTemplate extends  ConfigInfo{
	public id:number;
	public score:number;

	public attrs(){
		return ['id','score'];
	}
}

class PetRefreshTimeTemplate extends  ConfigInfo{
	public number:number;
	public times:number;

	public attrs(){
		return ['number','times'];
	}
}

class GrowthfundTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public reward:any;

	public attrs(){
		return ['id','level','reward'];
	}
}

class GlobalTemplate extends  ConfigInfo{
	public key:number;
	public value:number;

	public attrs(){
		return ['key','value'];
	}
}

class BuyItNowPriceTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public days:number;
	public rechargeId:number;
	public timeDes:number;
	public reward:any;
	public des:string;
	public mainUiBtn:string;

	public attrs(){
		return ['id','businessActivitiesId','number','days','rechargeId','timeDes','reward','des','mainUiBtn'];
	}
}

class XianlvjinjieTemplate extends  ConfigInfo{
	public stage:number;
	public nextstage:number;
	public exp:number;
	public need:number;
	public tempExpItem:Array<number>;
	public sliver:any;
	public tenttr:any;
	public allattr:any;
	public allMagicattr:any;

	public attrs(){
		return ['stage','nextstage','exp','need','tempExpItem','sliver','tenttr','allattr','allMagicattr'];
	}
}

class GlobalValueTemplate extends  ConfigInfo{
	public key:number;
	public value:any;

	public attrs(){
		return ['key','value'];
	}
}

class StarFightStarRewardTemplate extends  ConfigInfo{
	public chapter:number;
	public sixStars:any;
	public twelveStars:any;
	public eighteenStars:any;

	public attrs(){
		return ['chapter','sixStars','twelveStars','eighteenStars'];
	}
}

class RoleSkillLevelUpTemplate extends  ConfigInfo{
	public level:number;
	public SoulPower:any;

	public attrs(){
		return ['level','SoulPower'];
	}
}

class TotalConsumptionActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public consumption:number;
	public des:number;
	public reward:any;
	public order:number;

	public attrs(){
		return ['id','businessActivitiesId','number','consumption','des','reward','order'];
	}
}

class FactionTaskTemplate extends  ConfigInfo{
	public id:number;
	public minLevel:number;
	public maxLevel:number;
	public monster:Array<number>;

	public attrs(){
		return ['id','minLevel','maxLevel','monster'];
	}
}

class WingSkinTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public attribute:any;
	public cost:any;
	public model:number;

	public attrs(){
		return ['id','name','attribute','cost','model'];
	}
}

class ExperienceTemplate extends  ConfigInfo{
	public id:number;
	public min:number;
	public max:number;
	public exp:number;
	public reward:any;

	public attrs(){
		return ['id','min','max','exp','reward'];
	}
}

class FactionPostTemplate extends  ConfigInfo{
	public post:number;
	public name:number;
	public demise:number;
	public application:number;
	public kickOut:number;
	public position:number;
	public boss:number;
	public notice:number;
	public recruit:number;
	public incorporate:number;
	public rename:number;

	public attrs(){
		return ['post','name','demise','application','kickOut','position','boss','notice','recruit','incorporate','rename'];
	}
}

class MagicEggMakingTimesTemplate extends  ConfigInfo{
	public id:number;
	public makingType:number;
	public times:number;

	public attrs(){
		return ['id','makingType','times'];
	}
}

class RankActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public name:number;
	public type:number;
	public minRank:number;
	public maxRank:number;
	public minLevel:number;
	public reward:any;
	public des:number;
	public backFont:string;
	public showValue:number;
	public showWord:number;
	public goTo:any;

	public attrs(){
		return ['id','businessActivitiesId','number','name','type','minRank','maxRank','minLevel','reward','des','backFont','showValue','showWord','goTo'];
	}
}

class PetLoyaltyTemplate extends  ConfigInfo{
	public id:number;
	public loyaltyrange:any;
	public addloyalty:number;
	public loyaltyskill:any;

	public attrs(){
		return ['id','loyaltyrange','addloyalty','loyaltyskill'];
	}
}

class ShopTypeTemplate extends  ConfigInfo{
	public typeId:number;
	public name:number;
	public function:number;
	public order:number;
	public parameter:number;
	public parameterDes:number;
	public language:number;
	public getPath:any;
	public showMoneyType:any;

	public attrs(){
		return ['typeId','name','function','order','parameter','parameterDes','language','getPath','showMoneyType'];
	}
}

class TeamLevelTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public level:number;
	public monster:number;
	public scence:number;
	public fistPassReward:any;
	public passReward:any;
	public dropShow:any;
	public dropID:number;

	public attrs(){
		return ['id','name','level','monster','scence','fistPassReward','passReward','dropShow','dropID'];
	}
}

class CommonSkillTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public skillType:number;
	public name:number;
	public part:number;
	public level:number;
	public cost:any;
	public attribute:any;
	public icon:string;
	public openskill:number;

	public attrs(){
		return ['id','type','skillType','name','part','level','cost','attribute','icon','openskill'];
	}
}

class TreasureMapTemplate extends  ConfigInfo{
	public id:number;
	public mapid:number;
	public taskreward:any;

	public attrs(){
		return ['id','mapid','taskreward'];
	}
}

class WestboundLevelupTemplate extends  ConfigInfo{
	public level:number;
	public levelupexp:number;
	public attribute:any;
	public reward:any;
	public icon:string;
	public name:number;

	public attrs(){
		return ['level','levelupexp','attribute','reward','icon','name'];
	}
}

class PetRefreshTemplate extends  ConfigInfo{
	public mapID:number;
	public refreshpro:any;

	public attrs(){
		return ['mapID','refreshpro'];
	}
}

class RingrefreshTemplate extends  ConfigInfo{
	public id:number;
	public minRanking:number;
	public maxRanking:number;
	public minAddValue1:number;
	public maxAddValue1:number;
	public minAddValue2:number;
	public maxAddValue2:number;
	public minAddValue3:number;
	public maxAddValue3:number;
	public minAddValue4:number;
	public maxAddValue4:number;
	public minAddValue5:number;
	public maxAddValue5:number;

	public attrs(){
		return ['id','minRanking','maxRanking','minAddValue1','maxAddValue1','minAddValue2','maxAddValue2','minAddValue3','maxAddValue3','minAddValue4','maxAddValue4','minAddValue5','maxAddValue5'];
	}
}

class BusinessActivitiesTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public type:number;
	public time:any;
	public value:any;
	public openLevel:number;
	public functionType:number;
	public order:number;
	public redPoint:number;
	public backPicture:string;
	public backFont:string;
	public showValue:number;
	public showWord:number;
	public goTo:any;

	public attrs(){
		return ['id','name','type','time','value','openLevel','functionType','order','redPoint','backPicture','backFont','showValue','showWord','goTo'];
	}
}

class FunctionOpenTemplate extends  ConfigInfo{
	public functionId:number;
	public openLevel:number;
	public openVipLevel:number;
	public day:number;
	public worldLevel:number;
	public isShow:number;
	public name:number;
	public picture:number;
	public model:number;
	public scale:number;
	public x:number;
	public y:number;

	public attrs(){
		return ['functionId','openLevel','openVipLevel','day','worldLevel','isShow','name','picture','model','scale','x','y'];
	}
}

class WeaponSpiritTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name1:number;
	public name2:number;
	public name3:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model1:number;
	public model2:number;
	public model3:number;

	public attrs(){
		return ['id','level','name1','name2','name3','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model1','model2','model3'];
	}
}

class WingTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class HorseTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;
	public headModel:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model','headModel'];
	}
}

class PetArrayLeftTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class TaskTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public frontTaskId:number;
	public postTaskId:number;
	public targetType:number;
	public targetId:number;
	public targetNum:number;
	public reward:any;
	public guide:number;

	public attrs(){
		return ['id','name','frontTaskId','postTaskId','targetType','targetId','targetNum','reward','guide'];
	}
}

class FirstRechargeRewardTemplate extends  ConfigInfo{
	public id:number;
	public recharge:number;
	public reward:any;
	public icon:string;
	public des:number;

	public attrs(){
		return ['id','recharge','reward','icon','des'];
	}
}

class DevilgirlSkinTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public attribute:any;
	public cost:any;
	public model:number;

	public attrs(){
		return ['id','name','attribute','cost','model'];
	}
}

class TreasureRoutineTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public reward:any;
	public probability:number;
	public Mprobability:number;
	public broadcast:number;

	public attrs(){
		return ['id','type','reward','probability','Mprobability','broadcast'];
	}
}

class FactionTechTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public showPos:number;
	public cost:any;
	public attr:any;

	public attrs(){
		return ['id','level','showPos','cost','attr'];
	}
}

class PetUpgrageTemplate extends  ConfigInfo{
	public level:number;
	public exp:number;
	public consumeItem:any;
	public consumeMoney:any;
	public addexp:number;
	public levelupAttr:any;
	public levelupMagicAttr:any;

	public attrs(){
		return ['level','exp','consumeItem','consumeMoney','addexp','levelupAttr','levelupMagicAttr'];
	}
}

class RealNameAuthentificationTemplate extends  ConfigInfo{
	public id:number;
	public reward:any;

	public attrs(){
		return ['id','reward'];
	}
}

class VIPTemplate extends  ConfigInfo{
	public level:number;
	public money:number;
	public des:number;
	public picture:string;
	public icon:string;
	public chatIcon:string;
	public reward:any;
	public silverBuyTimes:number;
	public factionResetTimes:number;
	public mapBossBuyTimes:number;
	public ringreRefreshTimes:number;
	public dataLevelSweepTimes:number;
	public dailyAnswerResetTimes:number;
	public addOffTime:number;
	public addOffGlod:number;
	public addOffExp:number;

	public attrs(){
		return ['level','money','des','picture','icon','chatIcon','reward','silverBuyTimes','factionResetTimes','mapBossBuyTimes','ringreRefreshTimes','dataLevelSweepTimes','dailyAnswerResetTimes','addOffTime','addOffGlod','addOffExp'];
	}
}

class GemstoneTemplate extends  ConfigInfo{
	public id:number;
	public part:number;
	public level:number;
	public cost:any;
	public attrribute:any;
	public icon:any;

	public attrs(){
		return ['id','part','level','cost','attrribute','icon'];
	}
}

class MagicEggTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public icon:string;
	public model:number;
	public quality:number;
	public attr:any;
	public skillId:number;

	public attrs(){
		return ['id','name','icon','model','quality','attr','skillId'];
	}
}

class DevilgirlBookTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class HorseSkinTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public attribute:any;
	public cost:any;
	public model:number;
	public headModel:number;

	public attrs(){
		return ['id','name','attribute','cost','model','headModel'];
	}
}

class FinishApprenticeshipTemplate extends  ConfigInfo{
	public type:number;
	public name:number;
	public cost:any;
	public apprenticeExp:number;
	public apprenticeReward:any;
	public masterReward:any;

	public attrs(){
		return ['type','name','cost','apprenticeExp','apprenticeReward','masterReward'];
	}
}

class SkilleffectTemplate extends  ConfigInfo{
	public effectid:number;
	public effecttype:number;
	public actionkey:number;
	public flytime:number;
	public spaceframe:Array<number>;
	public effecthang:number;
	public isMulti:number;
	public isdir:number;
	public source:number;
	public scale:number;

	public attrs(){
		return ['effectid','effecttype','actionkey','flytime','spaceframe','effecthang','isMulti','isdir','source','scale'];
	}
}

class SkillTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public desc:number;
	public icon:string;
	public belong:number;
	public unlocklevel:number;
	public skilltype:number;
	public condition:number;
	public subtype:number;
	public parameter:any;
	public element:number;
	public acttarget:number;
	public actnumber:number;
	public addbuff:any;
	public actratio:number;
	public addactratio:number;
	public skillpower:number;
	public addskillpower:number;
	public skilleventid:number;
	public speech:any;

	public attrs(){
		return ['id','name','desc','icon','belong','unlocklevel','skilltype','condition','subtype','parameter','element','acttarget','actnumber','addbuff','actratio','addactratio','skillpower','addskillpower','skilleventid','speech'];
	}
}

class UpgradeRewardActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public name:number;
	public type:number;
	public level:number;
	public reward:any;
	public des:number;
	public backFont:string;
	public showValue:number;
	public showWord:number;
	public goTo:any;

	public attrs(){
		return ['id','businessActivitiesId','number','name','type','level','reward','des','backFont','showValue','showWord','goTo'];
	}
}

class OutpostPassTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public name:number;
	public type:number;
	public value:number;
	public des:number;
	public reward:any;
	public backFont:string;
	public showValue:number;
	public showWord:number;
	public goTo:any;

	public attrs(){
		return ['id','businessActivitiesId','number','name','type','value','des','reward','backFont','showValue','showWord','goTo'];
	}
}

class MusicCfgTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public name:string;
	public time:number;

	public attrs(){
		return ['id','type','name','time'];
	}
}

class DemonLevelTemplate extends  ConfigInfo{
	public id:number;
	public openLevel:number;
	public monsterListId:number;
	public dropId:number;
	public rewardShow:any;
	public flopRewardId:number;

	public attrs(){
		return ['id','openLevel','monsterListId','dropId','rewardShow','flopRewardId'];
	}
}

class HavocHeavenRewardTemplate extends  ConfigInfo{
	public chapter:number;
	public level:number;
	public reward:any;

	public attrs(){
		return ['chapter','level','reward'];
	}
}

class CrossServerCraftTemplate extends  ConfigInfo{
	public id:number;
	public minRank:number;
	public maxRank:number;
	public des:number;
	public desBack:string;
	public reward:any;

	public attrs(){
		return ['id','minRank','maxRank','des','desBack','reward'];
	}
}

class NoticeTemplate extends  ConfigInfo{
	public id:number;
	public content:number;
	public order:number;
	public repeatTimes:number;

	public attrs(){
		return ['id','content','order','repeatTimes'];
	}
}

class FactionPurchaseTemplate extends  ConfigInfo{
	public id:number;
	public item:number;
	public cost:any;
	public pro:number;

	public attrs(){
		return ['id','item','cost','pro'];
	}
}

class TreasureTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public smalltype:number;
	public time:Array<number>;

	public attrs(){
		return ['id','type','smalltype','time'];
	}
}

class LanguageCfg extends  ConfigInfo{
	public id:number;
	public text:string;
	public flag:number;

	public attrs(){
		return ['id','text','flag'];
	}
}

class WorshipTemplate extends  ConfigInfo{
	public id:number;
	public min:number;
	public max:number;
	public exp:number;

	public attrs(){
		return ['id','min','max','exp'];
	}
}

class FactionBossTemplate extends  ConfigInfo{
	public id:number;
	public bossValue:number;

	public attrs(){
		return ['id','bossValue'];
	}
}

class WestboundTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public name:number;
	public times:number;
	public exp:number;
	public link:any;
	public functionOpenId:number;

	public attrs(){
		return ['id','type','name','times','exp','link','functionOpenId'];
	}
}

class MagicEggHoleLevelupTemplate extends  ConfigInfo{
	public id:number;
	public consume:any;
	public attrPercentUp:number;

	public attrs(){
		return ['id','consume','attrPercentUp'];
	}
}

class AllUpgradeActivityTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public name:number;
	public type:number;
	public level:number;
	public num:number;
	public des:number;
	public reward:any;
	public backFont:string;
	public showValue:number;
	public showWord:number;
	public goTo:any;

	public attrs(){
		return ['id','businessActivitiesId','number','name','type','level','num','des','reward','backFont','showValue','showWord','goTo'];
	}
}

class DailyRechargeRewardTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public rechargeNum:number;
	public reward:any;
	public picture:string;
	public desYellow:string;
	public desGreen:string;

	public attrs(){
		return ['id','businessActivitiesId','number','rechargeNum','reward','picture','desYellow','desGreen'];
	}
}

class ArtifactSkinTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public attribute:any;
	public cost:any;
	public model:number;

	public attrs(){
		return ['id','name','attribute','cost','model'];
	}
}

class StrengthenTemplate extends  ConfigInfo{
	public id:number;
	public part:number;
	public level:number;
	public cost:any;
	public attribute:any;

	public attrs(){
		return ['id','part','level','cost','attribute'];
	}
}

class FactionPrayTemplate extends  ConfigInfo{
	public type:number;
	public name:number;
	public cost:any;
	public language:number;
	public incense:number;
	public guildExp:number;
	public guildContribution:number;

	public attrs(){
		return ['type','name','cost','language','incense','guildExp','guildContribution'];
	}
}

class CrossServerCraftSymbolTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public name:number;
	public nameBack:string;
	public value:number;
	public times:number;
	public model:string;
	public pickNotice:number;

	public attrs(){
		return ['id','type','name','nameBack','value','times','model','pickNotice'];
	}
}

class MagicSpiritTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class PillsTemplate extends  ConfigInfo{
	public id:number;
	public itemID:number;

	public attrs(){
		return ['id','itemID'];
	}
}

class MagicEggMakingNeedTemplate extends  ConfigInfo{
	public id:number;
	public itemId:number;
	public itemNum:number;
	public plusPro:number;
	public makingType:number;

	public attrs(){
		return ['id','itemId','itemNum','plusPro','makingType'];
	}
}

class EquipTemplate extends  ConfigInfo{
	public id:number;
	public icon:string;
	public job:number;
	public name:number;
	public type:number;
	public lv:number;
	public quality:number;
	public part:number;
	public attr:any;
	public analyse:any;

	public attrs(){
		return ['id','icon','job','name','type','lv','quality','part','attr','analyse'];
	}
}

class WeaponLeaseTemplate extends  ConfigInfo{
	public id:number;
	public businessActivitiesId:number;
	public number:number;
	public deposit:any;
	public equipID:number;

	public attrs(){
		return ['id','businessActivitiesId','number','deposit','equipID'];
	}
}

class RefineTemplate extends  ConfigInfo{
	public id:number;
	public part:number;
	public level:number;
	public cost:any;
	public attrribute:any;

	public attrs(){
		return ['id','part','level','cost','attrribute'];
	}
}

class PetPassiveSkillTemplate extends  ConfigInfo{
	public id:number;
	public skillId:number;
	public skillName:number;
	public group:number;
	public level:number;
	public skilltype:number;
	public phyle:number;
	public coverRate:number;
	public addClever:number;

	public attrs(){
		return ['id','skillId','skillName','group','level','skilltype','phyle','coverRate','addClever'];
	}
}

class RankingsTemplate extends  ConfigInfo{
	public id:number;
	public minRanking:number;
	public maxRanking:number;
	public npcId:number;
	public reward:any;
	public combatPower:number;

	public attrs(){
		return ['id','minRanking','maxRanking','npcId','reward','combatPower'];
	}
}

class MessageTempalte extends  ConfigInfo{
	public id:number;
	public type:number;
	public value:Array<number>;
	public channel:number;
	public showLevel:Array<number>;
	public content:number;

	public attrs(){
		return ['id','type','value','channel','showLevel','content'];
	}
}

class RoleLevelAttriTemplate extends  ConfigInfo{
	public level:number;
	public hp:number;
	public basicAttack:number;
	public basicDefense:number;
	public physicalCrit:number;
	public physicalCritDef:number;
	public physicalHit:number;
	public physicalDodge:number;
	public attackSpeed:number;
	public spellCrit:number;
	public spellCritDef:number;
	public spellHit:number;
	public spellDodge:number;

	public attrs(){
		return ['level','hp','basicAttack','basicDefense','physicalCrit','physicalCritDef','physicalHit','physicalDodge','attackSpeed','spellCrit','spellCritDef','spellHit','spellDodge'];
	}
}

class XianlvJihuoTemplate extends  ConfigInfo{
	public id:number;
	public condition:any;
	public att:any;
	public name:number;
	public phyle:number;
	public pz:number;
	public maxlevel:number;
	public model:number;
	public icon:string;

	public attrs(){
		return ['id','condition','att','name','phyle','pz','maxlevel','model','icon'];
	}
}

class BuffTemplate extends  ConfigInfo{
	public id:number;
	public name:number;
	public group:number;
	public level:number;
	public stackType:number;
	public roundType:number;
	public round:number;
	public buffOrDebuff:number;
	public attrEffect:any;
	public specialEffect:number;
	public showBuffText:number;
	public showEffect:any;
	public additionalEffect:number;

	public attrs(){
		return ['id','name','group','level','stackType','roundType','round','buffOrDebuff','attrEffect','specialEffect','showBuffText','showEffect','additionalEffect'];
	}
}

class RoleAttributeTemplate extends  ConfigInfo{
	public ID:number;
	public name:number;
	public type:number;
	public unittype:number;
	public quality:number;
	public des:number;
	public icon:number;
	public getPath:number;

	public attrs(){
		return ['ID','name','type','unittype','quality','des','icon','getPath'];
	}
}

class GhostsTemplate extends  ConfigInfo{
	public id:number;
	public mapid:number;
	public npcId:number;
	public models:any;
	public addrewardmodel:number;
	public visitreward:any;
	public killreward:any;
	public addreward:number;
	public addrewardshow:any;
	public taskreward:any;

	public attrs(){
		return ['id','mapid','npcId','models','addrewardmodel','visitreward','killreward','addreward','addrewardshow','taskreward'];
	}
}

class XianlvqiyuanTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public allatt:any;

	public attrs(){
		return ['id','level','allatt'];
	}
}

class PagodaLevelTemplate extends  ConfigInfo{
	public level:number;
	public npcId:number;
	public reward:any;
	public bj:number;

	public attrs(){
		return ['level','npcId','reward','bj'];
	}
}

class EquipmentAddAttributeTemplate extends  ConfigInfo{
	public id:number;
	public probability:any;

	public attrs(){
		return ['id','probability'];
	}
}

class ArenaBuyTimesTemplate extends  ConfigInfo{
	public times:number;
	public vipLevel:number;
	public money:any;

	public attrs(){
		return ['times','vipLevel','money'];
	}
}

class ErrorCodeTemplate extends  ConfigInfo{
	public id:number;
	public language:number;

	public attrs(){
		return ['id','language'];
	}
}

class StarFightTemplate extends  ConfigInfo{
	public id:number;
	public chapter:number;
	public monsterGroup:number;
	public firstReward:any;
	public reward:any;

	public attrs(){
		return ['id','chapter','monsterGroup','firstReward','reward'];
	}
}

class LevelrewardTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public reward:any;

	public attrs(){
		return ['id','level','reward'];
	}
}

class ShopTemplate extends  ConfigInfo{
	public id:number;
	public type:number;
	public content:any;
	public cost:any;
	public purchaseLimit:number;
	public numLimit:number;
	public showLevel:number;
	public unlockCondition:number;
	public value:number;
	public lockDes:number;
	public disappear:number;
	public order:number;
	public redPointType:number;
	public selectNum:number;

	public attrs(){
		return ['id','type','content','cost','purchaseLimit','numLimit','showLevel','unlockCondition','value','lockDes','disappear','order','redPointType','selectNum'];
	}
}

class SkyEarthFightTemplate extends  ConfigInfo{
	public id:number;
	public chapters:number;
	public chaptersName:number;
	public outpost:number;
	public outpostName:number;
	public monsterGroup:Array<number>;
	public dropShow:any;
	public firstReward:any;
	public reward:any;

	public attrs(){
		return ['id','chapters','chaptersName','outpost','outpostName','monsterGroup','dropShow','firstReward','reward'];
	}
}

class DevilgirlTemplate extends  ConfigInfo{
	public id:number;
	public level:number;
	public name:number;
	public quality:number;
	public exp:number;
	public peroperexp:number;
	public extraAttribute:any;
	public attribute:any;
	public tempExpItem:any;
	public expItem:any;
	public cost:any;
	public part:number;
	public unlockskill:number;
	public unlockequip:number;
	public equiplevel:number;
	public power:number;
	public model:number;

	public attrs(){
		return ['id','level','name','quality','exp','peroperexp','extraAttribute','attribute','tempExpItem','expItem','cost','part','unlockskill','unlockequip','equiplevel','power','model'];
	}
}

class FactionContributionTemplate extends  ConfigInfo{
	public id:number;
	public item:number;
	public factionExp:number;
	public banggong:number;

	public attrs(){
		return ['id','item','factionExp','banggong'];
	}
}

class MonsterListTemplate extends  ConfigInfo{
	public npcId:number;
	public npcname:number;
	public monstermodleid:number;
	public monster8:number;

	public attrs(){
		return ['npcId','npcname','monstermodleid','monster8'];
	}
}

class HavocHeavenTemplate extends  ConfigInfo{
	public level:number;
	public monsterteam:number;
	public model:number;
	public IsBoss:number;
	public chapter:number;
	public reward:any;
	public fight:number;

	public attrs(){
		return ['level','monsterteam','model','IsBoss','chapter','reward','fight'];
	}
}

