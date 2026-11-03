package com.ayjs.mxzg.common.reflect;

import java.lang.reflect.Field;

import com.esotericsoftware.reflectasm.FieldAccess;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class FieldInvoker {
	
	private final int fieldIndex;
	
	private final Field field;
	
	private final FieldAccess fieldAccess;
	
	public static FieldInvoker create(Class<?> classType, Field field){
		field.setAccessible(true);
		FieldAccess fieldAccess = FieldAccess.get(classType);
		int fieldIndex = fieldAccess.getIndex(field.getName());
		FieldInvoker fieldInvoker = new FieldInvoker(fieldIndex, field, fieldAccess);
		return fieldInvoker;
	}
	
	public static FieldInvoker create(FieldAccess fieldAccess, Field field){
		field.setAccessible(true);
		int fieldIndex = fieldAccess.getIndex(field.getName());
		FieldInvoker fieldInvoker = new FieldInvoker(fieldIndex, field, fieldAccess);
		return fieldInvoker;
	}
	
	public Field getField(){
		return field;
	}
	
	public void set(Object object, Object value){
		fieldAccess.set(object, fieldIndex, value);
	}
	
	public void set(Object object, Integer value){
		fieldAccess.setInt(object, fieldIndex, value);
	}
	
	public void set(Object object, Double value){
		fieldAccess.setDouble(object, fieldIndex, value);
	}
	
	public void set(Object object, Boolean value){
		fieldAccess.setBoolean(object, fieldIndex, value);
	}
	
	public void set(Object object, Byte value){
		fieldAccess.setByte(object, fieldIndex, value);
	}
	
	public void set(Object object, Float value){
		fieldAccess.setFloat(object, fieldIndex, value);
	}
	
	public void set(Object object, Long value){
		fieldAccess.setLong(object, fieldIndex, value);
	}
	
	public void set(Object object, char value){
		fieldAccess.setChar(object, fieldIndex, value);
	}
	
	public void set(Object object, short value){
		fieldAccess.setShort(object, fieldIndex, value);
	}
	
	public Object get(Object object){
		return fieldAccess.get(object, fieldIndex);
	}
	
	public int getInt(Object object){
		return fieldAccess.getInt(object, fieldIndex);
	}
		
	public Double getDouble(Object object, Double value){
		return fieldAccess.getDouble(object, fieldIndex);
	}
	
	public Boolean getBoolean(Object object, Boolean value){
		return fieldAccess.getBoolean(object, fieldIndex);
	}
	
	public Byte getByte(Object object, Byte value){
		return fieldAccess.getByte(object, fieldIndex);
	}
	
	public Float getFloat(Object object, Float value){
		return fieldAccess.getFloat(object, fieldIndex);
	}
	
	public Long getLong(Object object, Long value){
		return fieldAccess.getLong(object, fieldIndex);
	}
	
	public char getChar(Object object, char value){
		return fieldAccess.getChar(object, fieldIndex);
	}
	
	public short getShort(Object object, short value){
		return fieldAccess.getShort(object, fieldIndex);
	}
}
