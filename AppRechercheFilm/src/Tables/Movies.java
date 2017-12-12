package Tables;

import java.sql.*;

public class Movies
{
    private int ID;
    private String Title;
    private String Original_Title;
    private String Status;
    private Date Release_Date;
    private int Vote_Average;
    private int Vote_Count;
    private String Certification;
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

    public String getStatus(){return Status;}
    public void setStatus(String Status){this.Status = Status;}

    public Date getRelease_Date(){return Release_Date;}
    public void setRelease_Date(Date Release_Date){this.Release_Date = Release_Date;}

    public int getVote_Average(){return Vote_Average;}
    public void setVote_Average(int Vote_Average){this.Vote_Average = Vote_Average;}

    public int getVote_Count(){return Vote_Count;}
    public void setVote_Count(int Vote_Count){this.Vote_Count = Vote_Count;}

    public String getCertification(){return Certification;}
    public void setCertification(String Certification){this.Certification = Certification;}

    public int getRuntime(){return Runtime;}
    public void setRuntime(int Runtime){this.Runtime = Runtime;}

    public Blob getPoster(){return Poster;}
    public void setPoster(Blob Poster){this.Poster = Poster;}


    public void getMovieFromResultset(ResultSet res){
        try {
            ID = res.getInt(1);
            Title = res.getString(2);
            Original_Title = res.getString(3);
            Status = res.getString(4);
            Release_Date = res.getDate(5);
            Vote_Average = res.getInt(6);
            Vote_Count = res.getInt(7);
            Certification = res.getString(8);
            Runtime = res.getInt(9);
            Poster = res.getBlob(10);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public String toString()
    {
        return "Movies{" + "Title=" + Title + '}';
    }
}

