package com.ayjs.mxzg.common.akka;

import akka.actor.ActorRef;
import akka.actor.ActorSystem;
import akka.actor.ActorSystemImpl;
import akka.actor.TypedActor;
import akka.actor.TypedProps;
import com.typesafe.config.Config;
import com.typesafe.config.ConfigFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Method;


final public class AkkaContext {
	
	private static Logger logger = LoggerFactory.getLogger(AkkaContext.class);
	
	private static final ActorSystem SYSTEM;
	
	public static ActorSystem system(){
		return SYSTEM;
	}
	
	private static StringBuilder builder = new StringBuilder();
	
	static {
		builder.append("\n	akka {");
		builder.append("\n		actor {");
		builder.append("\n			default-dispatcher {");
		builder.append("\n				type = Dispatcher");
		builder.append("\n				executor = \"fork-join-executor\"");
		builder.append("\n				fork-join-executor {");
		//最少线程数4
		builder.append("\n					parallelism-min = 4");
		builder.append("\n					parallelism-factor = 3");
		//最大线程数16
		builder.append("\n					parallelism-max = 16");
		builder.append("\n				}");
		builder.append("\n			}");
		builder.append("\n		}");
		builder.append("\n	}");
		
		Config config = ConfigFactory.parseString(builder.toString());
		SYSTEM = ActorSystem.create("SYSTEM", config);
	}

	/**
	 * 打印jvm中所有的actor
	 *
	 * 用于检查actor泄露
	 */
	public static void printActors(){
		try{
			Method m = ActorSystemImpl.class.getDeclaredMethod("printTree");
			logger.info((String) m.invoke(SYSTEM));
		} catch (Exception e) {
			logger.error("!!!", e);
		}
	}

	/**
	 * 尽快停止一个TypedActor
	 * @param o
	 */
	public static void stopTypedActor(Object o){
		TypedActor.get(SYSTEM).stop(o);
	}
	
	/**
	 * 执行所有任务后停止一个TypedActor
	 * @param o
	 */
	public static void poisonPillActor(Object o){
		TypedActor.get(SYSTEM).poisonPill(o);
	}
	

	/**
	 * 创建一个TypedActor
	 * @param interfaceCls
	 * @param implementationCls
	 * @param <T>
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T> T createTypedActor(Class<T> interfaceCls, Class implementationCls) {
		return TypedActor.get(SYSTEM).typedActorOf(new TypedProps<T>(interfaceCls, implementationCls));
	}

	/**
	 * 获得一个TypedActor的ActorRef
	 *
	 * @param typedActor
	 * @return
	 */
	public static ActorRef getTypedActorRef(Object typedActor) {
		return TypedActor.get(SYSTEM).getActorRefFor(typedActor);
	}

	/**
	 * 获取一个远程的TypedActor
	 *
	 * @param interfaceCls
	 * @param actorRef
	 * @param <T>
	 * @return
	 */
	public static <T> T getRemoteTypedActor (Class<T> interfaceCls, ActorRef actorRef){
		return TypedActor.get(SYSTEM).typedActorOf(new TypedProps<T>(interfaceCls), actorRef);
	}
}
