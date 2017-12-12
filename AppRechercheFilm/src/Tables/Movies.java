package Tables;

import java.sql.Blob;
import java.sql.Date;
import java.sql.SQLData;
import java.sql.SQLException;
import java.sql.SQLInput;
import java.sql.SQLOutput;

public class Movies implements SQLData
{
    private int ID;
    private String Title;
    private String Original_Title;
    private int Status;
    private Date Release_Date;
    private int Vote_Average;
    private int Vote_Count;
    private int Certification;
    private int Runtime;
    private Blob Poster;

    public Movies()
    {
    }

    public int getID(){return ID;}
    public void setID(int ID){this.ID = ID;}

    public String getTitle(){return Title;}
    public void setTitle(String Title){this.Title = Title;}

    public String getOriginal_Title(){return Original_Title;}
    public void setOriginal_Title(String Original_Title){this.Original_Title = Original_Title;}

    public int getStatus(){return Status;}
    public void setStatus(int Status){this.Status = Status;}

    public Date getRelease_Date(){return Release_Date;}
    public void setRelease_Date(Date Release_Date){this.Release_Date = Release_Date;}

    public int getVote_Average(){return Vote_Average;}
    public void setVote_Average(int Vote_Average){this.Vote_Average = Vote_Average;}

    public int getVote_Count(){return Vote_Count;}
    public void setVote_Count(int Vote_Count){this.Vote_Count = Vote_Count;}

    public int getCertification(){return Certification;}
    public void setCertification(int Certification){this.Certification = Certification;}

    public int getRuntime(){return Runtime;}
    public void setRuntime(int Runtime){this.Runtime = Runtime;}

    public Blob getPoster(){return Poster;}
    public void setPoster(Blob Poster){this.Poster = Poster;}

    @Override
    public String getSQLTypeName() throws SQLException
    {
        return "MOVIES";
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException
    {
        setID(stream.readInt());
        setTitle(stream.readString());
        setOriginal_Title(stream.readString());
        setStatus(stream.readInt());
        setRelease_Date(stream.readDate());
        setVote_Average(stream.readInt());
        setVote_Count(stream.readInt());
        setCertification(stream.readInt());
        setRuntime(stream.readInt());
        setPoster(stream.readBlob());
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException
    {
        stream.writeInt(getID());
        stream.writeString(getTitle());
        stream.writeString(getOriginal_Title());
        stream.writeInt(getStatus());
        stream.writeDate(getRelease_Date());
        stream.writeInt(getVote_Average());
        stream.writeInt(getVote_Count());
        stream.writeInt(getCertification());
        stream.writeInt(getRuntime());
        stream.writeBlob(getPoster());
    }

    @Override
    public String toString()
    {
        return "Movies{" + "Title=" + Title + '}';
    }
}

