/*==============================================================*/
/* DBMS name:      PostgreSQL 9.x                               */
/* Created on:     16/07/2024 7:40:00 p. m.                     */
/*==============================================================*/


/*==============================================================*/
/* Table: accesos                                               */
/*==============================================================*/
create table accesos (
   cod_usuario          int4                 not null,
   correo_acceso        varchar(150)         not null,
   clave_acceso         varchar(150)         not null,
   constraint pk_accesos primary key (cod_usuario)
);

-- set table ownership
alter table accesos owner to user_admin
;
/*==============================================================*/
/* Index: inidice_correo                                        */
/*==============================================================*/
create unique index inidice_correo on accesos (
correo_acceso
);

/*==============================================================*/
/* Table: funcionalidad_usuario                                 */
/*==============================================================*/
create table funcionalidad_usuario (
   cod_usuario          int4                 not null,
   cod_funcionalidad    int4                 not null,
   constraint pk_funcionalidad_usuario primary key (cod_funcionalidad, cod_usuario)
);

-- set table ownership
alter table funcionalidad_usuario owner to user_admin
;
/*==============================================================*/
/* Table: funcionalidades                                       */
/*==============================================================*/
create table funcionalidades (
   cod_funcionalidad    serial not null,
   cod_padre            int4                 null,
   orden_funcionalidad  int2                 not null,
   nombre_funcionalidad varchar(100)         not null,
   url_funcionalidad    varchar(200)         not null,
   icono_funcionalidad  varchar(200)         not null default 'none',
   etiqueta_funcionalidad varchar(200)         not null default 'none',
   target_funcionalidad varchar(100)         not null default 'none',
   visible_funcionalidad bool                 not null default true,
   actividad_funcionalidad bool                 not null,
   constraint pk_funcionalidades primary key (cod_funcionalidad)
);

-- set table ownership
alter table funcionalidades owner to user_admin
;
/*==============================================================*/
/* Table: imagenes                                              */
/*==============================================================*/
create table imagenes (
   cod_imagen           serial not null,
   cod_usuario          int4                 not null,
   nombre_publico_imagen varchar(200)         not null,
   nombre_privado_imagen varchar(200)         not null,
   tipo_imagen          varchar(50)          not null,
   tamanio_imagen       varchar(50)          not null,
   favorita_imagen      int2                 not null default 2
      constraint ckc_favorita_imagen_imagenes check (favorita_imagen in (1,2)),
   constraint pk_imagenes primary key (cod_imagen)
);

comment on column imagenes.favorita_imagen is
'1 seleccionada
2 otras';

-- set table ownership
alter table imagenes owner to user_admin
;
/*==============================================================*/
/* Table: ingresos                                              */
/*==============================================================*/
create table ingresos (
   cod_ingreso          serial not null,
   cod_usuario          int4                 not null,
   fecha_ingreso        date                 not null,
   hora_ingreso         time                 not null,
   constraint pk_ingresos primary key (cod_ingreso)
);

-- set table ownership
alter table ingresos owner to user_admin
;
/*==============================================================*/
/* Table: roles                                                 */
/*==============================================================*/
create table roles (
   cod_rol              serial not null,
   nombre_rol           varchar(150)         not null,
   estado_rol           int2                 not null default 1
      constraint ckc_estado_rol_roles check (estado_rol in (1,2)),
   constraint pk_roles primary key (cod_rol)
);

comment on column roles.estado_rol is
'1 activo
2 inactivo';

-- set table ownership
alter table roles owner to user_admin
;
/*==============================================================*/
/* Table: usuarios                                              */
/*==============================================================*/
create table usuarios (
   cod_usuario          serial not null,
   cod_rol              int4                 not null,
   documento_usuario    varchar(50)          not null,
   tipo_documento_usuario varchar(4)           not null
      constraint ckc_tipo_documento_us_usuarios check (tipo_documento_usuario in ('11','12','13','21','22','31','41','42','47','50','91')),
   nombres_usuario      varchar(100)         not null,
   apellidos_usuario    varchar(100)         not null,
   telefono_usuario     varchar(50)          not null,
   email_usuario        varchar(200)         null,
   direccion_usuario    text                 null,
   estado_usuario       int2                 not null default 3
      constraint ckc_estado_usuario_usuarios check (estado_usuario in (1,2,3)),
   constraint pk_usuarios primary key (cod_usuario)
);

comment on column usuarios.estado_usuario is
'1 activo
2 inactivo
3 no verificado';

-- set table ownership
alter table usuarios owner to user_admin
;
/*==============================================================*/
/* Index: indice_doc                                            */
/*==============================================================*/
create unique index indice_doc on usuarios (
documento_usuario
);

alter table accesos
   add constraint fk_accesos_ref_usuarios foreign key (cod_usuario)
      references usuarios (cod_usuario)
      on delete restrict on update cascade;

alter table funcionalidad_usuario
   add constraint fk_funciona_ref_funciona foreign key (cod_funcionalidad)
      references funcionalidades (cod_funcionalidad)
      on delete restrict on update cascade;

alter table funcionalidad_usuario
   add constraint fk_funciona_ref_usuarios foreign key (cod_usuario)
      references usuarios (cod_usuario)
      on delete restrict on update cascade;

alter table funcionalidades
   add constraint fk_func_ref_func foreign key (cod_padre)
      references funcionalidades (cod_funcionalidad)
      on delete restrict on update cascade;

alter table imagenes
   add constraint fk_imagenes_ref_usuarios foreign key (cod_usuario)
      references usuarios (cod_usuario)
      on delete restrict on update cascade;

alter table ingresos
   add constraint fk_ingresos_ref_accesos foreign key (cod_usuario)
      references accesos (cod_usuario)
      on delete restrict on update cascade;

alter table usuarios
   add constraint fk_usuarios_ref_roles foreign key (cod_rol)
      references roles (cod_rol)
      on delete restrict on update cascade;

