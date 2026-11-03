package com.ayjs.mxzg.common.scheduler;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

public class ScheduledTaskRegistry {

    private final ThreadPoolTaskScheduler scheduler;
    private final Set<Object> identityRegistry = new HashSet<>();
    private final List<CronTask> cronTasks = new ArrayList<>();
    private final List<IntervalTask> fixedDelayTasks = new ArrayList<>();
    private final Set<ScheduledTask> scheduledTasks = new LinkedHashSet<>();

    public ScheduledTaskRegistry(ThreadPoolTaskScheduler scheduler) {
        this.scheduler = scheduler;
    }

    public void register(CronTask task) {
        registerIdentity(task.getIdentity());
        cronTasks.add(task);
    }

    public void register(FixedDelayTask task) {
        registerIdentity(task.getIdentity());
        fixedDelayTasks.add(task);
    }

    private void registerIdentity(Object identity) {
        if (!identityRegistry.add(Objects.requireNonNull(identity))) {
            throw new RuntimeException(String.format("task{%s} duplicated", identity));
        }
    }

    public void scheduleTasks() {
        cronTasks.forEach(task -> addScheduledTask(scheduleCronTask(task)));
        fixedDelayTasks.forEach(task -> addScheduledTask(scheduleFixedDelayTask(task)));
    }

    public void cancelTasks() {
        scheduledTasks.forEach(ScheduledTask::cancel);
    }

    private void addScheduledTask(ScheduledTask task) {
        scheduledTasks.add(task);
    }

    private ScheduledTask scheduleCronTask(CronTask task) {
        return new ScheduledTask(scheduler.schedule(task));
    }

    private ScheduledTask scheduleFixedDelayTask(IntervalTask task) {
        return new ScheduledTask(scheduler.scheduleFixedDelayTask(task));
    }
}
