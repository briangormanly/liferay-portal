<#setting number_format = "0">

<#assign groupIds = dataFactory.addUserToGroupIds(group.groupId)>
<#assign organizationIds = []>
<#assign roleIds = [dataFactory.administratorRole.roleId, dataFactory.powerUserRole.roleId, dataFactory.userRole.roleId]>

<#assign firstNames = dataFactory.userNames?first>
<#assign lastNames = dataFactory.userNames?last>

<#assign userCounter = dataFactory.newInteger()>

<#list lastNames as lastName>
	<#list firstNames as firstName>
		<#assign userCounterIncrement = userCounter.increment()>

		<#assign contact = dataFactory.addContact(firstName, lastName)>
		<#assign user = dataFactory.addUser(false, "test" + userScreenNameCounter.get())>

		<#assign userGroup = dataFactory.addGroup(counter.get(), dataFactory.userClassNameId, user.userId, stringUtil.valueOf(user.userId), "/" + user.screenName, false)>

		${sampleSQLBuilder.insertGroup(userGroup, [], [dataFactory.addLayout(1, "Home", "/home", "", "33,")])}

		${sampleSQLBuilder.insertUser(contact, groupIds, organizationIds, roleIds, user)}

		<#assign blogsStatsUser = dataFactory.addBlogsStatsUser(groupId, user.userId)>

		insert into BlogsStatsUser (statsUserId, groupId, companyId, userId) values (${counter.get()}, ${blogsStatsUser.groupId}, ${companyId}, ${blogsStatsUser.userId});

		<#assign mbStatsUser = dataFactory.addMBStatsUser(groupId, user.userId)>

		insert into MBStatsUser (statsUserId, groupId, userId) values (${counter.get()}, ${mbStatsUser.groupId}, ${mbStatsUser.userId});

		${writerUserCSV.write(user.getScreenName() + "," + userGroup.groupId + ",")}

		<#if (userCounter.value < maxUserCount)>
			${writerUserCSV.write("\n")}
		</#if>

		<#if (lastName_index = 0) && (firstName_index = 0)>
			<#assign firstUserId = user.userId>
		</#if>

		<#if (userCounter.value >= maxUserCount)>
			${writerUserCSV.write("\n")}

			<#break>
		</#if>
	</#list>

	<#if (userCounter.value >= maxUserCount)>
		<#break>
	</#if>
</#list>