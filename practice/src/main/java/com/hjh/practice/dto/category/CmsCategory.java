package com.hjh.practice.dto.category;

public class CmsCategory {

    private Long id;
    private String name;
    private String slug;
    private Long parentId;
    private String parentName;
    private String description;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }
    public String getParentName() { return parentName; }
    public void setParentName(String parentName) { this.parentName = parentName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
