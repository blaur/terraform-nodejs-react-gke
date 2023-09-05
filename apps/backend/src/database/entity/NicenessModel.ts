import { Entity, PrimaryGeneratedColumn, Column } from "typeorm"

@Entity()
export class NicenessModel {

    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column()
    nicenessScore: number;
}