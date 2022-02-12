package com.java.proiect.mapper;

import com.java.proiect.dto.CreateGroupDtoToGroup;
import com.java.proiect.dto.UpdateGroupDtoToGroupArtists;
import com.java.proiect.dto.UpdateGroupDtoToGroupSimple;
import com.java.proiect.model.Group;
import org.springframework.stereotype.Component;

@Component
public class GroupMapper {
    public Group addGroupDtoToGroup(CreateGroupDtoToGroup request) {
        if(request.getArtists() != null) {
            return new Group(request.getName(), request.getNoMembers(),
                    request.getYearDebut(), request.getYearDisbandment(), request.getArtists());
        }
        return new Group(request.getName(), request.getNoMembers(),
                request.getYearDebut(), request.getYearDisbandment());
    }

    public Group updateGroupDtoToGroup(UpdateGroupDtoToGroupSimple request) {
        return new Group(request.getId(), request.getName(), request.getYearDebut(), request.getYearDisbandment());
    }

    public Group updateGroupDtoArtists(UpdateGroupDtoToGroupArtists request) {
        return new Group(request.getId(), request.getNoMembers(), request.getArtists());
    }
}
