/*
 *  Enums.h
 *  MessagesService
 *

 *  Copyright 2011 QuickBlox team. All rights reserved.
 *
 */

typedef enum QBMEventType{
	QBMEventTypeOneShot,
    QBMEventTypeFixedDate,
    QBMEventTypePeriodDate,
    QBMEventTypeMultiShot
} QBMEventType;

typedef enum QBMEventActionType{
	QBMEventActionTypeNone,
	QBMEventActionTypeOptional,
	QBMEventActionTypeRequired
} QBMEventActionType;